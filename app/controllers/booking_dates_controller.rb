class BookingDatesController < ApplicationController
  def index
    
  end

  def update 
    @booking = BookingDate.find(params[:id])
    @booking.update(available: false)
    redirect_to online_consultations_path
  end 

 
end 