require "test_helper"

class Donations::CreatePaymentTest < ActiveSupport::TestCase
  Response = Struct.new(:code, :body)

  setup do
    @donation = DonationRequest.new(
      category: "general",
      amount: 1_000,
      payment_method: "upi",
      donor_name: "Anita Rao",
      email: "anita@example.com",
      mobile: "9876543210"
    )
  end

  test "posts the API key server-side and accepts the allowlisted payment URL" do
    captured_request = nil
    transport = lambda do |_uri, request|
      captured_request = request
      Response.new(
        "200",
        JSON.generate(
          status: "success",
          data: { donation_id: 861, payment_url: "https://donate.satsang-foundation.org/donate/status?id=861" }
        )
      )
    end

    result = Donations::CreatePayment.new(donation: @donation, api_key: "test-key", transport: transport).call

    assert result.success?
    assert_equal "test-key", captured_request["X-API-Key"]
    payload = JSON.parse(captured_request.body)
    assert_equal "healthcare", payload.fetch("cause")
    assert_equal "general", payload.fetch("sub_cause")
  end

  test "rejects a payment redirect on an unexpected host" do
    transport = lambda do |_uri, _request|
      Response.new("200", JSON.generate(status: "success", data: { payment_url: "https://example.com/payment" }))
    end

    result = Donations::CreatePayment.new(donation: @donation, api_key: "test-key", transport: transport).call

    assert_not result.success?
    assert_equal "Payment URL not received.", result.message
  end

  test "returns allowlisted field errors from an API failure" do
    transport = lambda do |_uri, _request|
      Response.new(
        "422",
        JSON.generate(status: "error", message: "Validation failed", errors: { amount: "Amount is invalid", unknown: "Ignored" })
      )
    end

    result = Donations::CreatePayment.new(donation: @donation, api_key: "test-key", transport: transport).call

    assert_not result.success?
    assert_equal "Validation failed", result.message
    assert_equal({ "amount" => "Amount is invalid" }, result.errors)
  end

  test "does not call the API without a configured key" do
    transport = ->(*) { flunk "transport should not be called" }

    result = Donations::CreatePayment.new(donation: @donation, api_key: nil, transport: transport).call

    assert_not result.success?
    assert_equal "Online donations are temporarily unavailable.", result.message
  end
end
