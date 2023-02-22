class BookingMailer < ApplicationMailer
  def booking_email(booking)
    @booking = booking
    mail(to: "arogyamtesting@gmail.com", subject: "New Booking Form Message")
  end
end