class VishraamRegistration < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :duration, presence: true
  attr_accessor :agreement
  attr_accessor :terms

  before_destroy :send_cancel_email

  validates :lifestyle, :substances, :health_conditions, :medication, presence: true
  validates :agreement, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create
  validates :terms, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create

  private 

  def send_cancel_email 
    vishraam_registration_data = {
      date: self.date,
      email: self.user.email
    }
    VishraamRegistrationMailer.vishraam_registration_cancel_email(vishraam_registration_data).deliver_later
  end 

  DURATION_OPTIONS = {
    '3 days' => 3,
    '5 days' => 5
  }
end
