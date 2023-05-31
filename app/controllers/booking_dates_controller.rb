class BookingDatesController < ApplicationController
  def index
    
  end

  def update 
    @booking = BookingDate.find(params[:id])
    if @booking.update(available: false, status: "BLOCKED")
      render json: @booking
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end 

 
end 