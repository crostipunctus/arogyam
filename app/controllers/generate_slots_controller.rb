class GenerateSlotsController < ApplicationController 
  def index 
    BookingDate.generate_default_slots
  end 

end 