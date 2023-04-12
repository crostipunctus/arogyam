class NewsletterSubscription < ApplicationRecord
  validates :email, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  after_create :subscribe_to_mailchimp

  private

  def subscribe_to_mailchimp
    # return if Rails.env.development? || ENV["SKIP_MAILCHIMP"] == "true"
    response = MailchimpService.new(email).subscribe
    Rails.logger.info "Mailchimp API response: #{response.inspect}"

  end
end