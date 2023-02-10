class ContactsController < ApplicationController
  def index 
    @contact = Contact.new 
  end 

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Thank you for contacting us. We will get back to you soon.'
    else
      flash.now[:error] = 'Could not send message'
      render :new
    end
  end
end
