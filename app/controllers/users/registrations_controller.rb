# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  after_action :subscribe_to_newsletter, only: [:create]
  respond_to :html, :json
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    
  end

  # POST /resource
  def create
    recaptcha_token = params[:recaptcha_token]
    recaptcha_success = verify_recaptcha(secret_key: Rails.application.credentials.recaptcha[:secret_key], response: recaptcha_token, action: 'register')

    if recaptcha_success
      super
    else
      self.resource = resource_class.new sign_up_params
      resource.validate # Check for other validation errors besides reCAPTCHA
      set_minimum_password_length
      respond_with_navigational(resource) { render :new }
    end
  end

  #GET /resource/edit
  def edit
   super
  end

  #PUT /resource
  def update
   super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :privacy_policy, :recaptcha_token])
  end

  private 

  def subscribe_to_newsletter
    if resource.persisted? && resource.newsletter_subscription == "1"
      if Rails.env.development?
        # Log the action instead of making an API call in development
        Rails.logger.info "Newsletter subscription: Would subscribe #{resource.email} to newsletter in production."
      else
        # Actual subscription logic for non-development environments
        gibbon = Gibbon::Request.new(api_key: Rails.application.credentials.gibbon[:api])
        list_id = "5b6215d26b" # Replace with your actual list ID
  
        begin
          response = gibbon.lists(list_id).members.create(
            body: {
              email_address: resource.email,
              status: "subscribed"
            }
          )
          flash[:notice] = "You have been successfully subscribed to the newsletter."
        rescue Gibbon::MailChimpError => e
          handle_mailchimp_error(e)
        end
      end
    else
      flash[:alert] = "There was an error with the CAPTCHA verification. Please try again."
    end
  end
  


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
 
end
