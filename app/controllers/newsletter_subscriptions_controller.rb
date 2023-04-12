class NewsletterSubscriptionsController < ApplicationController
  def create
    @newsletter_subscription = NewsletterSubscription.new(newsletter_subscription_params)

    if @newsletter_subscription.save
      flash[:notice] = 'You have successfully subscribed to the newsletter!'
      redirect_to root_path
    else
      flash[:error] = 'There was an error with your subscription. Please try again.'
      redirect_to root_path
    end
  end

  private

  def newsletter_subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
