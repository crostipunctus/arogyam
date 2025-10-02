class OnlineConsultationMailer < ApplicationMailer
  def online_consultation_email(online_consultation)
    @online_consultation = online_consultation
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultation@arogyam.life',
      to: email_address,
      subject: 'Online Consultation Booked(unconfirmed)'
    )
  end

  def online_consultation_confirmation_email(online_consultation)
    @online_consultation = online_consultation
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultation@arogyam.life',
      to: email_address,
      subject: 'Online Consultation Booked(confirmed)'
    )
  end

  def online_consultation_cancellation_email(online_consultation)
    @online_consultation = online_consultation
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultation@arogyam.life',
      to: email_address,
      subject: 'Online Consultation Cancelled'
    )
  end

  def online_consultation_user_confirmation_email(online_consultation)
    @online_consultation = online_consultation
    @user = @online_consultation.user
    email_address = Rails.env.production? ? @user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultation@arogyam.life',
      to: email_address,
      subject: 'Your Consultation is Confirmed!'
    )
  end

  def online_consultation_user_cancellation_email(online_consultation)
    @online_consultation = online_consultation
    @user = @online_consultation.user
    email_address = Rails.env.production? ? @user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultations@arogyam.life',
      to: email_address,
      subject: 'Your Consultation is Cancelled!'
    )
  end

  def review_consultation_email(online_consultation)
    @online_consultation = online_consultation
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultations@arogyam.life',
      to: email_address,
      subject: 'Review Consultation Booked'
    )
  end

  def online_consultation_payment_confirmation_email(online_consultation)
    @online_consultation = online_consultation
    @user = @online_consultation.user
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultations@arogyam.life',
      to: email_address,
      subject: 'Payment Confirmation'
    )
  end

  def online_consultation_payment_user_confirmation_email(online_consultation)
    @online_consultation = online_consultation
    @user = @online_consultation.user
    email_address = Rails.env.production? ? @user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultations@arogyam.life',
      to: email_address,
      subject: 'Payment Confirmation'
    )
  end

  def online_consultation_reschedule_email(online_consultation)
    @online_consultation = online_consultation
    @user = @online_consultation.user
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultations@arogyam.life',
      to: email_address,
      subject: 'Consultation Rescheduled'
    )
  end

  def online_consultation_reschedule_user_email(online_consultation)
    @online_consultation = online_consultation
    @user = @online_consultation.user
    email_address = Rails.env.production? ? @user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'OnlineConsultations@arogyam.life',
      to: email_address,
      subject: 'Consultation Rescheduled'
    )
  end
end
