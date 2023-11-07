class VishraamRegistrationsController < ApplicationController 
  
  before_action :authenticate_user! 
  before_action :require_admin, only: [:index, :edit, :update ]

  def index 
    case params[:filter]
    when 'all'
      @vishraam_registrations = VishraamRegistration.all.page(params[:page]).per(10)
      
    when 'cancelled'
      @vishraam_registrations = VishraamRegistration.where(cancelled: true).page(params[:page]).per(10)
    when 'completed'
      @vishraam_registrations = VishraamRegistration.where(completed: true).page(params[:page]).per(10)
    when 'upcoming'
      @vishraam_registrations = VishraamRegistration.where("date > ?", Date.today)
                                             .where(cancelled: false, completed: false)
                                             .page(params[:page])

    when 'payment_complete'
      @vishraam_registrations = VishraamRegistration.where(status: 'Payment Completed').page(params[:page]).per(10)
    when 'payment_pending'
      @vishraam_registrations = VishraamRegistration.where(status: 'Payment Pending').page(params[:page]).per(10)
    else
      @vishraam_registrations = VishraamRegistration.where("date > ?", Date.today)
                                             .where(cancelled: false, completed: false)
                                             .page(params[:page])

    end

   
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
          VishraamRegistrationMailer.vishraam_registration_user_confirmation_email(@vishraam_registration).deliver_later
          @vishraam_registration.update(status: "Registered")
          redirect_to programmes_path, notice: "Vishram registration successful"
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
        @vishraam_registration.update_column(:comments, vishraam_registration_params[:comments])
        @vishraam_registration.update(completed: true) if vishraam_registration_params[:status] == "Completed"
        format.json { render json: { status: :ok, message: "Vishraam registration was successfully updated." } }
      else
        Rails.logger.error "Failed to update registration with id: #{params[:id]}, errors: #{@vishraam_registration.errors.full_messages}"
        format.json { render json: { status: :unprocessable_entity, message: "Failed to update Vishraam registration.", errors: @vishraam_registration.errors.full_messages } }
      end
    end
  end
  
  def destroy 
    @vishraam_registration = VishraamRegistration.find(params[:id])
    if @vishraam_registration.update(status: "Cancelled")
      @vishraam_registration.update(cancelled: true)
      VishraamRegistrationMailer.vishraam_registration_cancel_email(@vishraam_registration).deliver_later
      VishraamRegistrationMailer.vishraam_registration_user_cancellation_email(@vishraam_registration).deliver_later
    else
      puts @vishraam_registration.errors.full_messages
    end

    redirect_back fallback_location: root_path, notice: "Vishram registration deleted"
  end

  

  private 

  def vishraam_registration_params 
    params.require(:vishraam_registration).permit(:date, :duration, :substances, :health_conditions, :medication, :lifestyle, :agreement, :terms, :status, :comments, :completed, :cancelled)
  end 

  

end