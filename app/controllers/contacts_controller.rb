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
      flash[:notice] = 'Thank you for contacting us. We will get back to you soon.'
      redirect_to contacts_path
    else
      flash.now[:alert] = 'Could not send message'
      render :index
    end
  end
end
