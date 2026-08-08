require "test_helper"

class DonationRequestTest < ActiveSupport::TestCase
  test "builds the documented API payload from normalized donor details" do
    donation = DonationRequest.new(
      category: "wellness-care",
      amount: "1500",
      payment_method: "upi",
      donor_name: "  <b>Anita Rao</b>  ",
      email: " ANITA@example.com ",
      mobile: "+91 98765 43210",
      pan_number: "",
      message: " <i>With gratitude</i> "
    )

    assert donation.valid?, donation.errors.full_messages.to_sentence
    assert_equal "healthcare", donation.api_payload[:cause]
    assert_equal "wellness-care", donation.api_payload[:sub_cause]
    assert_equal "Anita Rao", donation.api_payload[:full_name]
    assert_equal "anita@example.com", donation.api_payload[:email]
    assert_equal "9876543210", donation.api_payload[:mobile]
    assert_equal "With gratitude", donation.api_payload[:message]
  end

  test "requires a valid PAN from the documented threshold" do
    donation = DonationRequest.new(
      category: "general",
      amount: "2000",
      payment_method: "card",
      donor_name: "Anita Rao",
      email: "anita@example.com",
      mobile: "9876543210",
      pan_number: ""
    )

    assert_not donation.valid?
    assert_includes donation.errors[:pan_number], "is required for donations of Rs. 2,000 or more"

    donation.pan_number = "abcde1234f"
    assert donation.valid?, donation.errors.full_messages.to_sentence
    assert_equal "ABCDE1234F", donation.api_payload[:pan_no]
  end

  test "rejects category and payment method values outside the allowlists" do
    donation = DonationRequest.new(category: "other", payment_method: "cash")

    assert_not donation.valid?
    assert donation.errors[:category].any?
    assert donation.errors[:payment_method].any?
  end

  test "rejects an amount above the configured safety ceiling" do
    donation = DonationRequest.new(
      category: "general",
      amount: DonationRequest::MAX_AMOUNT + 1,
      payment_method: "upi",
      donor_name: "Anita Rao",
      email: "anita@example.com",
      mobile: "9876543210",
      pan_number: "ABCDE1234F"
    )

    assert_not donation.valid?
    assert donation.errors[:amount].any?
  end
end
