class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :blogs, dependent: :destroy
  has_many :registrations, dependent: :destroy 
  has_many :batches, through: :registrations
  has_many :vishraam_registrations, dependent: :destroy

  has_one :user_profile, dependent: :destroy

  has_many :online_consultations, dependent: :destroy
  has_many :booking_dates, through: :online_consultations

  has_many :case_sheets, dependent: :destroy


  attr_accessor :accepts_privacy_policy
  validates :accepts_privacy_policy, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create

  # check if profile associated with the user has been created. 

  def confirm(*args, &block)
    previously_confirmed = confirmed?

    # Call Devise's original confirm method
    result = super(*args, &block)

    # If the user was not confirmed before and is confirmed now, send the welcome email
    unless previously_confirmed || !confirmed?
      WelcomeMailer.welcome_email(self).deliver_later
    end

    result
  end

  def has_online_consultations?
    online_consultations.exists?
  end

end
