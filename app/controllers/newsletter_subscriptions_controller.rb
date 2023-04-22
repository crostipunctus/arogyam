class NewsletterSubscriptionsController < ApplicationController
 
    def create
     
      email = params[:newsletter_subscription][:email]
  
      # Initialize Gibbon with your Mailchimp API key
      gibbon = Gibbon::Request.new(api_key: Rails.application.credentials.gibbon[:api])
  
      # Replace "your_list_id" with the ID of the Mailchimp list you want to add the user to
      list_id = "5b6215d26b"
  
      begin
        # Subscribe the user to the list
        response = gibbon.lists(list_id).members.create(
          body: {
            email_address: email,
            status: "subscribed"
          }
        )
        puts response
        flash[:notice] = "You have been successfully subscribed to the newsletter."
      rescue Gibbon::MailChimpError => e
        if e.status_code == 400 && e.title == "Member Exists"
          flash[:notice] = "You have already subscribed!"
        else
          puts e.message
          flash[:alert] = "There was an error subscribing you to the newsletter: #{e.message}"
        end      
      end
      redirect_to root_path
    end
 
    
  private

  def newsletter_subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
