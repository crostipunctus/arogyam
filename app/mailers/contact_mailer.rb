class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    
    mail(
      from: 'ContactForm@arogyam.life',
      to: email_address,
      subject: 'Contact Form Enquiry'
    )
  end
end
