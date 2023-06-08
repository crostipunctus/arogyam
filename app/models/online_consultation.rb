class OnlineConsultation < ApplicationRecord
  belongs_to :user
  belongs_to :booking_date
  has_many :case_sheets

 

  def confirmed? 
    status == "confirmed"
  end 

  


end 