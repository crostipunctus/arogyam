module OnlineConsultationHelper

  def last_consultation_within_a_month?(user)
    last_consultation = user.online_consultations.where(completed: true).last
    
    last_consultation && last_consultation.date < 1.month.ago
  end
  


end