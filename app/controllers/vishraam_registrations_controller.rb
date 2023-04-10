class VishraamRegistrationsController < ApplicationController 
  require 'pdfkit'
  before_action :authenticate_user! 
  before_action :require_admin, only: [:index, :edit, :update ]

  def index 
    @vishraam_registrations = VishraamRegistration.all
  end 

  def new 
    @vishraam_registration = VishraamRegistration.new
  end 

  def create 
    if current_user.user_profile
      @vishraam_registration = VishraamRegistration.new(vishraam_registration_params)
      @vishraam_registration.user_id = current_user.id
     
        if @vishraam_registration.save
          

          redirect_to packages_path, notice: "Vishraam registration successful"
        else
          flash[:error] = "Vishraam registration failed"
          render 'new'
        end
      
    else  
      redirect_to new_user_profile_path(user_id: current_user.id), alert: "Please complete your profile before registering for a batch"
    end 
  end 

  def edit 

  end 

  def update 

  end 

  def destroy 

  end

  def pdf 

  end 

  private 

  def vishraam_registration_params 
    params.require(:vishraam_registration).permit(:date, :duration)
  end 

end