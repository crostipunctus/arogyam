class ContactsController < ApplicationController
  def index 
    @contact = Contact.new
  end 
  
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save 
      ContactMailer.contact_email(@contact).deliver_later
      redirect_to root_path, notice: "Your message has been sent. We will get back to you soon."
    else  
      render :new, alert: "Something went wrong. Try again."
    end 
  end

  private 

  def contact_params 
    params.require(:contact).permit(:name, :email, :message)
  end 
end