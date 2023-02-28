class BookingsController < ApplicationController
  def index  
    @name = params[:name]
    @booking = Booking.new
  end 

  def create
    @booking = Booking.new(booking_params)
    if @booking.save 
      BookingMailer.booking_email(@booking).deliver_later
      redirect_to bookings_path, notice: "Your message has been sent. We will get back to you soon."
    else  
      render :index, status: :unprocessable_entity, alert: 'You message could not be sent. Please try again.'
    end 
  end

  private 

  def booking_params 
    params.require(:booking).permit(:name, :email, :message, :package_id)
  end 


end 