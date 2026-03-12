class NewsletterSubscriptionsController < ApplicationController

  def create
    email = params[:newsletter_subscription][:email]
    recaptcha_token = params['g-recaptcha-response']
    recaptcha_secret_key = Rails.application.credentials.recaptcha_v2[:secret_key]

    uri = URI.parse('https://www.google.com/recaptcha/api/siteverify')
    response = Net::HTTP.post_form(uri, 'secret' => recaptcha_secret_key, 'response' => recaptcha_token)
    result = JSON.parse(response.body)

    if result['success']
      gibbon = Gibbon::Request.new(api_key: Rails.application.credentials.gibbon[:api])
      list_id = "5b6215d26b"

      begin
        gibbon.lists(list_id).members.create(
          body: {
            email_address: email,
            status: "subscribed"
          }
        )
        @message = "You have been successfully subscribed to the newsletter."
        @message_type = "success"
        flash.now[:ga_event] = { name: 'newsletter_signup', params: { method: 'mailchimp' } }
      rescue Gibbon::MailChimpError => e
        handle_mailchimp_error(e)
      end
    else
      @message = "There was an error with the CAPTCHA verification. Please try again."
      @message_type = "error"
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: @message }
    end
  end

  private

  def handle_mailchimp_error(e)
    if e.status_code == 400 && e.title == "Member Exists"
      @message = "You are already subscribed!"
      @message_type = "success"
    else
      @message = "There was an error subscribing you to the newsletter: #{e.message}"
      @message_type = "error"
    end
  end

  def newsletter_subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
