class NewsletterSubscription < ApplicationRecord
  validates :email, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  #after_create :subscribe_to_mailchimp

 
end