class RegistrationMailer < ApplicationMailer
  def registration_email(registration)
    @registration = registration
    mail(to: "arogyamtesting@gmail.com", subject: "New Batch Registration")
  end

  def registration_cancel_email(registration_data)
    @registration_data = registration_data
    mail(to: "arogyamtesting@gmail.com", subject: "Batch Registration Cancelled")
  end 
end