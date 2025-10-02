class RegistrationMailer < ApplicationMailer
  def registration_email(registration)
    @registration = registration
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM@arogyam.life',
      to: email_address,
      subject: 'New Registration'
    )
  end

  def registration_cancel_email(registration_data)
    @registration_data = registration_data
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM@arogyam.life',
      to: email_address,
      subject: 'Registration Cancelled'
    )
  end

  def registration_user_email(registration)
    @registration = registration
    email_address = Rails.env.production? ? @registration.user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM@arogyam.life',
      to: email_address,
      subject: 'You registered for a health programme!'
    )
  end

  def registration_cancel_user_email(registration)
    @registration = registration
    email_address = Rails.env.production? ? @registration.user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM@arogyam.life',
      to: email_address,
      subject: 'Registration cancelled'
    )
  end
end
