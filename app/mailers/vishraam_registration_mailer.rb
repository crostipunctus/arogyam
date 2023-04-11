class VishraamRegistrationMailer < ApplicationMailer
  def vishraam_registration_email(vishraam_registration)
    @vishraam_registration = vishraam_registration
    mail(to: "arogyamtesting@gmail.com", subject: "New Vishraam Registration")
  end
end