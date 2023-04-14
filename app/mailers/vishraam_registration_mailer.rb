class VishraamRegistrationMailer < ApplicationMailer
  def vishraam_registration_email(vishraam_registration)
    @vishraam_registration = vishraam_registration
    mail(to: "arogyamtesting@gmail.com", subject: "New Vishraam Registration")
  end

  def vishraam_registration_cancel_email(vishraam_registration_data)
    @vishraam_registration_data = vishraam_registration_data
    mail(to: "arogyamtesting@gmail.com", subject: "New Vishraam Cancellation")
  end
end

