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
      list_id = "5b6215d26b" # Replace with your actual list ID
  
      begin
        response = gibbon.lists(list_id).members.create(
          body: {
            email_address: email,
            status: "subscribed"
          }
        )
        flash[:notice] = "You have been successfully subscribed to the newsletter."
      rescue Gibbon::MailChimpError => e
        handle_mailchimp_error(e)
      end
    else
      flash[:alert] = "There was an error with the CAPTCHA verification. Please try again."
    end
  
    redirect_to root_path
  end
  
 
 
 
    
  private

  def handle_mailchimp_error(e)
    if e.status_code == 400 && e.title == "Member Exists"
      flash[:notice] = "You have already subscribed!"
    else
      flash[:alert] = "There was an error subscribing you to the newsletter: #{e.message}"
    end
  end
  

  def newsletter_subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
 