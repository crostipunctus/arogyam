class OnlineConsultation < ApplicationRecord
  belongs_to :user
  belongs_to :booking_date
  has_many :case_sheets

  def confirmed? 
    status == "confirmed"
  end 

  def review_consultation(online_consultation)
    
  end


end 