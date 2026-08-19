class DonationsController < ApplicationController
  SUGGESTED_AMOUNTS = [500, 1_000, 2_500, 5_000, 10_000].freeze

  def index
    @donation = DonationRequest.new
    prepare_form
  end

  def create
    @donation = DonationRequest.new(donation_params)
    prepare_form

    unless valid_recaptcha?
      @donation.errors.add(:base, "We could not verify that request. Please try again.")
      return render :index, status: :unprocessable_entity
    end

    return render :index, status: :unprocessable_entity unless @donation.valid?
    return render_rate_limited unless donation_submission_allowed?

    result = Donations::CreatePayment.new(donation: @donation, api_key: donation_api_key).call

    if result.success?
      redirect_to result.payment_url, allow_other_host: true
    else
      apply_api_errors(result.errors)
      flash.now[:alert] = result.message
      render :index, status: :unprocessable_entity
    end
  end

  private

  def prepare_form
    @sub_causes = DonationRequest::SUB_CAUSES
    @suggested_amounts = SUGGESTED_AMOUNTS
    @donation_enabled = donation_api_key.present?
  end

  def donation_params
    params.require(:donation_request).permit(
      :category,
      :amount,
      :payment_method,
      :donor_name,
      :email,
      :mobile,
      :pan_number,
      :message
    )
  end

  def valid_recaptcha?
    recaptcha_verified_for?("donation")
  end

  def donation_api_key
    Rails.application.credentials.dig(:donation_api, :key).presence || ENV["DONATION_API_KEY"].presence
  end

  def donation_submission_allowed?
    session_throttle.allowed? && ip_throttle.allowed?
  end

  def session_throttle
    session[:donation_throttle_id] ||= SecureRandom.uuid
    Donations::SubmissionThrottle.new(identifier: "session:#{session[:donation_throttle_id]}")
  end

  def ip_throttle
    Donations::SubmissionThrottle.new(identifier: "ip:#{request.remote_ip}", limit: 20)
  end

  def render_rate_limited
    @donation.errors.add(:base, "Too many donation attempts. Please wait a few minutes and try again.")
    response.headers["Retry-After"] = Donations::SubmissionThrottle::WINDOW.to_i.to_s
    render :index, status: :too_many_requests
  end

  def apply_api_errors(errors)
    field_mapping = {
      "sub_cause" => :category,
      "full_name" => :donor_name,
      "pan_no" => :pan_number
    }

    errors.each do |field, message|
      @donation.errors.add(field_mapping.fetch(field, field), message)
    end
  end
end
