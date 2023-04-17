class Registration < ApplicationRecord
  belongs_to :user 
  belongs_to :batch 
  belongs_to :package

  before_destroy :send_cancel_email

  validates :lifestyle, :substances, :health_conditions, :medication, presence: true

  private 

  def send_cancel_email 
    registration_data = {
      batch: self.batch.start_date,
      email: self.user.email
    }
    RegistrationMailer.registration_cancel_email(registration_data).deliver_later
  end 
  
end
