class DonationRequest
  include ActiveModel::Model

  API_CAUSE = "healthcare".freeze
  PAN_THRESHOLD = 2_000
  MAX_AMOUNT = 10_000_000

  SUB_CAUSES = [
    {
      key: "general",
      name: "Where It Is Needed Most",
      description: "Give ArogyaM the flexibility to direct support towards its most important current needs.",
      icon: "compass"
    },
    {
      key: "wellness-care",
      name: "Wellness Care Support",
      description: "Help extend thoughtful Ayurvedic and yogic wellness support to people who may need assistance.",
      icon: "heart"
    },
    {
      key: "community-outreach",
      name: "Community Wellness",
      description: "Support wellness awareness, learning, and outreach initiatives for the wider community.",
      icon: "people"
    },
    {
      key: "healing-spaces",
      name: "Healing Spaces & Equipment",
      description: "Contribute towards nurturing ArogyaM's spaces and the equipment used in its wellness work.",
      icon: "flower"
    }
  ].map(&:freeze).freeze

  PAYMENT_METHODS = {
    "upi" => "UPI",
    "card" => "Credit or debit card",
    "netbanking" => "Net banking"
  }.freeze

  attr_accessor :category, :payment_method
  attr_writer :amount, :donor_name, :email, :mobile, :pan_number, :message

  validates :category, inclusion: { in: SUB_CAUSES.map { |sub_cause| sub_cause[:key] }, message: "Please select a donation category." }
  validates :amount, numericality: {
    greater_than: 0,
    less_than_or_equal_to: MAX_AMOUNT,
    message: "Please enter a valid donation amount up to Rs. 1 crore."
  }
  validates :donor_name, presence: { message: "Name is required." }, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 254 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile, format: { with: /\A[6-9]\d{9}\z/, message: "must be a valid 10-digit Indian mobile number" }
  validates :payment_method, inclusion: { in: PAYMENT_METHODS.keys }
  validates :pan_number, presence: { message: "is required for donations of Rs. 2,000 or more" }, if: :pan_required?
  validates :pan_number, format: { with: /\A[A-Z]{5}\d{4}[A-Z]\z/, message: "is invalid" }, allow_blank: true
  validates :message, length: { maximum: 500 }

  def initialize(attributes = {})
    super({ category: SUB_CAUSES.first[:key], amount: 1_000, payment_method: "upi" }.merge(attributes.to_h.symbolize_keys))
  end

  def amount
    BigDecimal(@amount.to_s)
  rescue ArgumentError
    BigDecimal("0")
  end

  def donor_name
    clean_text(@donor_name).squish
  end

  def email
    @email.to_s.strip.downcase
  end

  def mobile
    digits = @mobile.to_s.gsub(/\D/, "")
    digits = digits.delete_prefix("91") if digits.length == 12 && digits.start_with?("91")
    digits
  end

  def pan_number
    @pan_number.to_s.strip.upcase
  end

  def message
    clean_text(@message).strip
  end

  def sub_cause
    selected_sub_cause&.fetch(:key)
  end

  def api_payload
    {
      cause: API_CAUSE,
      sub_cause: sub_cause,
      amount: api_amount,
      payment_method: payment_method,
      full_name: donor_name,
      email: email,
      mobile: mobile,
      pan_no: pan_number,
      message: message.presence || "Donation to ArogyaM"
    }
  end

  def pan_required?
    amount >= PAN_THRESHOLD
  end

  private

  def api_amount
    amount.frac.zero? ? amount.to_i : amount.to_f
  end

  def clean_text(value)
    ActionController::Base.helpers.strip_tags(value.to_s)
  end

  def selected_sub_cause
    SUB_CAUSES.find { |sub_cause| sub_cause[:key] == category }
  end
end
