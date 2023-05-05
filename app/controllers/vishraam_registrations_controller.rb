class VishraamRegistrationsController < ApplicationController 
  require 'pdfkit'
  before_action :authenticate_user! 
  before_action :require_admin, only: [:index, :edit, :update ]

  def index 
    @vishraam_registrations = VishraamRegistration.all
  end 

  def show 
    @vishraam_registration = VishraamRegistration.find(params[:id])
  end 

  def new 
    @vishraam_registration = VishraamRegistration.new
  end 

  def create 
    if current_user.user_profile
      @vishraam_registration = VishraamRegistration.new(vishraam_registration_params)
      @vishraam_registration.user_id = current_user.id
      
        if @vishraam_registration.save
          VishraamRegistrationMailer.vishraam_registration_email(@vishraam_registration).deliver_later
          @vishraam_registration.update(status: "Registered")
          redirect_to packages_path, notice: "Vishram registration successful"
        else
          flash[:error] = "Vishram registration failed"
          render :new, status: :unprocessable_entity 
        end
      
    else  
      redirect_to new_user_profile_path(user_id: current_user.id), alert: "Please complete your profile before registering for a batch"
    end 
  end 

  def edit 

  end 

  def update
    @vishraam_registration = VishraamRegistration.find(params[:id])
    respond_to do |format|
      if @vishraam_registration.update_column(:status, vishraam_registration_params[:status])
        format.json { render json: { status: :ok, message: "Vishraam registration was successfully updated." } }
      else
        Rails.logger.error "Failed to update registration with id: #{params[:id]}, errors: #{@vishraam_registration.errors.full_messages}"
        format.json { render json: { status: :unprocessable_entity, message: "Failed to update Vishraam registration.", errors: @vishraam_registration.errors.full_messages } }
      end
    end
  end
  
  def destroy 
    @vishraam_registration = VishraamRegistration.find(params[:id])
    @vishraam_registration.update(status: "Cancelled")

    redirect_back fallback_location: root_path, notice: "Vishram registration deleted"
  end

  

  private 

  def vishraam_registration_params 
    params.require(:vishraam_registration).permit(:date, :duration, :substances, :health_conditions, :medication, :lifestyle, :agreement, :terms, :status)
  end 

  

end