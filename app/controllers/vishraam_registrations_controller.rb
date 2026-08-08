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
    unless current_user_admin? || @vishraam_registration.user == current_user
      redirect_to root_path, alert: "You are not authorized to view this registration."
      return
    end
  end

  def new 
    if session[:vishraam_registration_params]
      @vishraam_registration = VishraamRegistration.new(session[:vishraam_registration_params])
    else 
      @vishraam_registration = VishraamRegistration.new 
    end
  end 

  def create
    recaptcha_token = params[:recaptcha_token]
    recaptcha_success = verify_recaptcha(secret_key: Rails.application.credentials.recaptcha[:secret_key], response: recaptcha_token, action: 'vishraam_registration')
    unless recaptcha_success
      @vishraam_registration = VishraamRegistration.new(vishraam_registration_params)
      flash.now[:alert] = "reCAPTCHA verification failed. Please try again."
      render :new, status: :unprocessable_entity
      return
    end

    if current_user.user_profile
      @vishraam_registration = VishraamRegistration.new(vishraam_registration_params)
      @vishraam_registration.user_id = current_user.id

      if @vishraam_registration.valid?
        session[:vishraam_registration_params] = @vishraam_registration.attributes
        redirect_to review_vishraam_registrations_path
      else
        flash.now[:error] = "Vishram registration failed: #{@vishraam_registration.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_user_profile_path(user_id: current_user.id),
                  alert: "Please complete your profile before registering for a batch"
    end
  end  

  def review 
    unless session[:vishraam_registration_params].present?
      redirect_to new_vishraam_registration_path, alert: "Please complete the registration form first."
      return
    end

    @vishraam_registration = VishraamRegistration.new(session[:vishraam_registration_params])
    @vishraam_registration.user = current_user
  end 

  def confirm 
    unless session[:vishraam_registration_params].present?
      redirect_to new_vishraam_registration_path, alert: "Please complete the registration form first."
      return
    end

    @vishraam_registration = VishraamRegistration.new(session[:vishraam_registration_params])
    @vishraam_registration.assign_attributes(
      user: current_user,
      status: "Registered",
      completed: false,
      cancelled: false
    )

    if @vishraam_registration.save
      session[:vishraam_registration_params] = nil 
      VishraamRegistrationMailer.vishraam_registration_email(@vishraam_registration).deliver_later
      VishraamRegistrationMailer.vishraam_registration_user_confirmation_email(@vishraam_registration).deliver_later
      flash[:ga_event] = { name: 'programme_registration', params: { programme: 'VishraM' } }
      redirect_to vishraam_registration_path(@vishraam_registration), notice: "You have successfully registered for VishraM. We will get back to you soon."
    else 
      render :review 
    end 
  end 

  def edit 

  end 

  def update
    @vishraam_registration = VishraamRegistration.find(params[:id])
    respond_to do |format|
      if @vishraam_registration.update_column(:status, vishraam_registration_admin_params[:status])
        @vishraam_registration.update_column(:comments, vishraam_registration_admin_params[:comments])
        @vishraam_registration.update(completed: true) if vishraam_registration_admin_params[:status] == "Completed"
        format.json { render json: { status: :ok, message: "Vishraam registration was successfully updated." } }
      else
        Rails.logger.error "Failed to update registration with id: #{params[:id]}, errors: #{@vishraam_registration.errors.full_messages}"
        format.json { render json: { status: :unprocessable_entity, message: "Failed to update Vishraam registration.", errors: @vishraam_registration.errors.full_messages } }
      end
    end
  end
  
  def destroy
    @vishraam_registration = VishraamRegistration.find(params[:id])
    unless current_user_admin? || @vishraam_registration.user == current_user
      redirect_to root_path, alert: "You are not authorized to cancel this registration."
      return
    end

    if @vishraam_registration.update(status: "Cancelled")
      @vishraam_registration.update(cancelled: true)
      VishraamRegistrationMailer.vishraam_registration_cancel_email(@vishraam_registration).deliver_later
      VishraamRegistrationMailer.vishraam_registration_user_cancellation_email(@vishraam_registration).deliver_later
    else
      Rails.logger.error "Failed to cancel vishraam registration: #{@vishraam_registration.errors.full_messages}"
    end

    redirect_back fallback_location: root_path, notice: "Vishram registration deleted"
  end

  

  private 

  def vishraam_registration_params 
    params.require(:vishraam_registration).permit(:date, :duration, :substances, :health_conditions, :medication, :lifestyle, :agreement, :terms)
  end

  def vishraam_registration_admin_params
    params.require(:vishraam_registration).permit(:status, :comments)
  end 

  

end
