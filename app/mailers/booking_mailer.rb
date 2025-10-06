class BookingMailer < ApplicationMailer
  def booking_email(booking)
    @booking = booking
    email_address = Rails.env.production? ? "arogyamtesting@gmail.com" : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      to: email_address,
      subject: 'Contact Form Enquiry'
    )
  end
end
