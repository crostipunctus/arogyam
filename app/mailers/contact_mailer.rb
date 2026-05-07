class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    email_address = Rails.env.production? ? ["admin@arogyam.life", "wellnesscenter@satsang-foundation.org"] : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      to: email_address,
      subject: 'Contact Form Enquiry'
    )
  end
end
