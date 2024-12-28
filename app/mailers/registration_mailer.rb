class RegistrationMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid
  
  default from: 'ArogyaM@arogyam.life'

  def registration_email(registration)
    @registration = registration
    mail(
      to: Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com",
      subject: 'New Registration'
    )
  end

  def registration_cancel_email(registration_data)
    @registration_data = registration_data
    mail(
      to: Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com",
      subject: 'Registration Cancelled'
    )
  end 

  def registration_user_email(registration)
    @registration = registration
    mail(
      to: Rails.env.production? ? @registration.user.email : "rshan.ali@gmail.com",
      subject: 'You registered for a health programme!'
    )
  end 

  def registration_cancel_user_email(registration)
    @registration = registration
    mail(
      to: Rails.env.production? ? @registration.user.email : "rshan.ali@gmail.com",
      subject: 'Registration cancelled'
    )
  end 
end