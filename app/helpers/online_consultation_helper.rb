module OnlineConsultationHelper

  def last_consultation_within_a_month?(user)
    user.online_consultations.where(completed: true).where('date > ?', 1.month.ago).exists?
  end
  


end