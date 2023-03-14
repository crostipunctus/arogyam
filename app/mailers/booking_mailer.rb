class BookingMailer < ApplicationMailer
  def booking_email(booking)
    @booking = booking
    mail(to: "arogyamtesting@gmail.com", subject: "Booking Form Enquiry", sender: @booking.name.capitalize)
  end
end