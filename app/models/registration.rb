class Registration < ApplicationRecord
  belongs_to :user 
  belongs_to :batch 
  belongs_to :package
  attr_accessor :agreement
  attr_accessor :terms

  after_create :registered
  after_create :cancelled
  before_destroy :send_cancel_email

  validates :lifestyle, :substances, :health_conditions, :medication, presence: true
  validates :agreement, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create
  validates :terms, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create

  
  private 

  def send_cancel_email 
    registration_data = {
      batch: self.batch.start_date,
      email: self.user.email
    }
    RegistrationMailer.registration_cancel_email(registration_data).deliver_later
  end 

  def registered 
    self.status = "Registered"
  end 

  def cancelled 
    self.cancelled = false 
  end 
  
end
