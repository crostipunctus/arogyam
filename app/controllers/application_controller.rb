require "digest"

class ApplicationController < ActionController::Base

  AUTHENTICATION_SUBMISSIONS = %w[
    devise/sessions#create
    devise/passwords#create
    devise/confirmations#create
    users/registrations#create
  ].freeze
  PUBLIC_FORM_SUBMISSIONS = %w[
    contacts#create
    donations#create
    newsletter_subscriptions#create
    registrations#create
    registrations#confirm
    vishraam_registrations#create
    vishraam_registrations#confirm
  ].freeze
  RATE_LIMIT_STORE = if Rails.env.test?
    ActiveSupport::Cache::MemoryStore.new
  else
    Rails.cache
  end

  helper_method :current_user_admin?
  helper_method :gallery_index
  helper_method :team_index
  helper_method :announcements
  helper_method :testimonials_preview
  protect_from_forgery with: :exception

  before_action :reject_null_byte_parameters
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_headers, if: -> { request.get? }

  rate_limit to: 10, within: 1.minute,
    by: :rate_limit_identity,
    with: :render_short_rate_limit,
    store: RATE_LIMIT_STORE,
    name: "authentication-burst",
    if: :authentication_submission?
  rate_limit to: 50, within: 1.hour,
    by: :rate_limit_identity,
    with: :render_long_rate_limit,
    store: RATE_LIMIT_STORE,
    name: "authentication-sustained",
    if: :authentication_submission?
  rate_limit to: 15, within: 1.minute,
    by: :rate_limit_identity,
    with: :render_short_rate_limit,
    store: RATE_LIMIT_STORE,
    name: "public-form-burst",
    if: :public_form_submission?
  rate_limit to: 100, within: 1.hour,
    by: :rate_limit_identity,
    with: :render_long_rate_limit,
    store: RATE_LIMIT_STORE,
    name: "public-form-sustained",
    if: :public_form_submission?

  def after_sign_in_path_for(resource_or_scope)

    stored_location_for(resource_or_scope) || super

  end

  private

  def authentication_submission?
    request.post? && AUTHENTICATION_SUBMISSIONS.include?(rate_limit_endpoint)
  end

  def public_form_submission?
    request.post? && PUBLIC_FORM_SUBMISSIONS.include?(rate_limit_endpoint)
  end

  def rate_limit_endpoint
    "#{controller_path}##{action_name}"
  end

  def rate_limit_identity
    Digest::SHA256.hexdigest("#{request.remote_ip}:#{rate_limit_endpoint}")
  end

  def render_short_rate_limit
    render_rate_limit(retry_after: 60)
  end

  def render_long_rate_limit
    render_rate_limit(retry_after: 1.hour.to_i)
  end

  def render_rate_limit(retry_after:)
    response.headers["Retry-After"] = retry_after.to_s
    render plain: "Too many attempts. Please wait and try again.", status: :too_many_requests
  end

  def reject_null_byte_parameters
    return unless contains_null_byte?(params) || contains_null_byte?(request.fullpath)

    Rails.logger.warn("Rejected request containing a null byte for #{controller_name}##{action_name}")
    head :bad_request
  end

  def contains_null_byte?(value)
    case value
    when String
      value.include?("\0")
    when Array
      value.any? { |item| contains_null_byte?(item) }
    when Hash, ActionController::Parameters
      value.each_pair.any? do |key, item|
        contains_null_byte?(key.to_s) || contains_null_byte?(item)
      end
    else
      false
    end
  end

  def recaptcha_verified_for?(action)
    recaptcha_token = params[:recaptcha_token]
    return false unless recaptcha_token.nil? || recaptcha_token.is_a?(String)

    verify_recaptcha(
      secret_key: Rails.application.credentials.dig(:recaptcha, :secret_key),
      response: recaptcha_token.to_s,
      action: action
    )
  end

  def storable_location?

    request.get? && session_cookie_present? && is_navigational_format? && !devise_controller? && !request.xhr?

  end

  def session_cookie_present?
    request.cookies.key?(Rails.application.config.session_options[:key])
  end

  def store_user_location!

    store_location_for(:user, request.fullpath)

  end

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access! You have to be an admin user!"
    end
  end

  def current_user_admin? 
    current_user && current_user.admin? 
  end 
 
  def gallery_index
    @gallery = Gallery.with_attached_images.first
  end



  def team_index 
    @team = TeamMember.with_attached_avatar.all 
  end 

  def announcements
    @announcement = Announcement.all
  end

  def testimonials_preview
    @testimonials_preview ||= Testimonial.limit(2)
  end 

  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:recaptcha_token, :newsletter_subscription])
  end

  def set_cache_headers
    response.headers["Cache-Control"] = if user_signed_in?
      "private, no-store"
    else
      "private, max-age=0, must-revalidate"
    end
    response.headers.delete("Expires")
  end

 

end
