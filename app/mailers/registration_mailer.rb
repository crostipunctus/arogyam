class RegistrationMailer < ApplicationMailer
  def registration_email(registration)
    @registration = registration
    mail(to: "arogyamtesting@gmail.com", subject: "New Batch Registration")
  end
end