class BookingsController < ApplicationController
  def index  
    @name = params[:name]
    @contact = Contact.new
  end 


end 