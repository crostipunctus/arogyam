require "test_helper"
require "minitest/mock"

class DonationsControllerTest < ActionDispatch::IntegrationTest
  test "donation form is publicly available" do
    get donate_path

    assert_response :success
    assert_select "h1", "Help wellbeing take root"
    assert_select "form[action='#{donate_path}'][method='post']"
    assert_select "input[name='donation_request[donor_name]']"
    assert_select "input[name='donation_request[amount]'][type='hidden']"
    assert_select "script[src^='https://www.google.com/recaptcha/api.js?render=']", count: 1
    assert_select "script[src='https://www.google.com/recaptcha/api.js']", count: 0
    assert_no_match(/X-API-Key/i, response.body)
  end

  test "invalid donation is not sent to the payment API" do
    post donate_path, params: {
      donation_request: {
        category: "invalid",
        amount: 0,
        payment_method: "upi",
        donor_name: "",
        email: "invalid",
        mobile: "123"
      }
    }

    assert_response :unprocessable_entity
    assert_select ".donation-error-summary"
  end

  test "valid donation redirects only through the payment service result" do
    payment_url = "https://donate.satsang-foundation.org/donate/status?id=861"
    result = Donations::CreatePayment::Result.new(payment_url: payment_url, errors: {})
    service = Object.new
    service.define_singleton_method(:call) { result }

    Donations::CreatePayment.stub(:new, ->(*, **) { service }) do
      post donate_path, params: {
        donation_request: {
          category: "general",
          amount: 1_000,
          payment_method: "upi",
          donor_name: "Anita Rao",
          email: "anita@example.com",
          mobile: "9876543210",
          pan_number: "",
          message: "Donation"
        }
      }
    end

    assert_redirected_to payment_url
  end

  test "rate-limited donations never reach the payment API" do
    throttle = Object.new
    throttle.define_singleton_method(:allowed?) { false }

    Donations::SubmissionThrottle.stub(:new, ->(*, **) { throttle }) do
      Donations::CreatePayment.stub(:new, ->(*, **) { flunk("payment API should not be called") }) do
        post donate_path, params: {
          donation_request: {
            category: "general",
            amount: 1_000,
            payment_method: "upi",
            donor_name: "Anita Rao",
            email: "anita@example.com",
            mobile: "9876543210"
          }
        }
      end
    end

    assert_response :too_many_requests
    assert_equal Donations::SubmissionThrottle::WINDOW.to_i.to_s, response.headers["Retry-After"]
    assert_select ".donation-error-summary", text: /Too many donation attempts/
  end
end
