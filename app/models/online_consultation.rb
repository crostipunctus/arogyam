class OnlineConsultation < ApplicationRecord
  belongs_to :user
  belongs_to :booking_date
  has_one :case_sheet

  def confirmed? 
    status == "confirmed"
  end 


end 