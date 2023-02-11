class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    mail(to: "arogyamtesting@gmail.com", subject: "New Contact Form Message")
  end
end