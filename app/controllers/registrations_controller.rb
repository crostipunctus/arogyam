class RegistrationsController < ApplicationController
 
  before_action :authenticate_user! 
  before_action :require_admin, only: [:index, :edit, :update ]
  
  def index 
    case params[:filter]
    when 'all'
      @registrations = Registration.all.page(params[:page]).per(10)
    when 'cancelled'
      @registrations = Registration.where(cancelled: true).page(params[:page]).per(10)
    when 'completed'
      @registrations = Registration.where(completed: true).page(params[:page]).per(10)
    when 'upcoming'
      @registrations = Registration.joins(:batch)
                             .where(cancelled: false, completed: false)
                             .where('batches.start_date > ?', Date.today).page(params[:page])
    when 'payment_complete'
      @registrations = Registration.where(status: 'Payment Completed').page(params[:page]).per(10)
    when 'payment_pending'
      @registrations = Registration.where(status: 'Payment Pending').page(params[:page]).per(10)
    else
      @registrations = Registration.joins(:batch)
      .where(cancelled: false, completed: false)
      .where('batches.start_date > ?', Date.today).page(params[:page])
    end
    @vishraam_registrations = VishraamRegistration.where("date > ?", Date.today)
    .where(cancelled: false, completed: false)
    .page(params[:page])
    @online_consultations = OnlineConsultation.all
    @batches = Batch.all 
    
  end

  def export_batch
    @batches = Batch.joins(:registrations).includes(registrations: { user: :user_profile }).distinct
  
    respond_to do |format|
      format.xlsx { render xlsx: 'registrations', filename: 'registrations.xlsx' }
    end
  end

  def export_vishraam
    @vishraam_registrations = VishraamRegistration.includes(user: :user_profile).all

    respond_to do |format|
      format.xlsx { render xlsx: 'vishraam_registrations', filename: 'vishraam_registrations.xlsx' }
    end
  end

  def show 
    @registration = Registration.find(params[:id])
  end

  def new
    if session[:registration_params]
      @registration = Registration.new(session[:registration_params])
    else
      @registration = Registration.new(batch_id: params[:batch_id])
    end
    
    if params[:package_id] && Package.exists?(params[:package_id])
      puts "Package id: #{params[:package_id]}"
      @selected_package_id = params[:package_id].to_i
    else
      @selected_package_id = nil
    end
  end
  

  def create
    puts "Registration params: #{registration_params}"
    @batch = Batch.find(params[:registration][:batch_id])
    
    if Registration.exists?(user: current_user, batch_id: @batch.id, status: "Registered")
      registration = Registration.find_by(user: current_user, batch_id: @batch.id)
     
      redirect_to batches_path, alert: "You have already registered for this batch"
    else
      @batch = Batch.find(params[:registration][:batch_id])
      @package = Package.find(params[:registration][:package_id])
      @registration = Registration.new(registration_params)
      @registration.user = current_user
      @registration.batch = @batch
      @registration.package = @package
  
      # Determine which duration field to use based on the package_id
      if @package.name == 'VishraM'
        @registration.duration = registration_params[:duration]
      elsif @package.name == 'ShamanaM'
        @registration.duration = registration_params[:shamanam_duration]
      end
  
      if @registration.valid?
        session[:registration_params] = @registration.attributes
        redirect_to review_registrations_path
      else
        render :new, status: :unprocessable_entity
      end
    end
    
  end

  def review
    @registration = Registration.new(session[:registration_params])
  end

  def confirm
    @registration = Registration.new(session[:registration_params])
    if @registration.save
      session[:registration_params] = nil
      RegistrationMailer.registration_email(@registration).deliver_later
      RegistrationMailer.registration_user_email(@registration).deliver_later
      @registration.update(status: "Registered")
      redirect_to batches_path, notice: "Registered successfully"
    else
      render :review
    end
  end
  
  

  def edit  
    @registration = Registration.find(params[:id])
    
  end 

  def update
    # when save comments button is clicked the status is updated to blank 
    @registration = Registration.find(params[:id])
    @batch = @registration.batch
    puts "Registration params: #{registration_params}"
    respond_to do |format|
      # Check if status is blank
      if registration_params[:status].blank?
        if @registration.update_column(:comments, registration_params[:comments])
          format.json { render json: { status: :ok, message: "Comments were successfully updated." } }
          format.html { redirect_to registrations_path, notice: "Comments were successfully updated." }
        else
          Rails.logger.error "Failed to update registration with id: #{params[:id]}, errors: #{@registration.errors.full_messages}"
          format.json { render json: { status: :unprocessable_entity, message: "Failed to update registration comments.", errors: @registration.errors.full_messages } }
        end
      else
        if @registration.update_column(:status, registration_params[:status])
          puts "Registration status updated to #{registration_params[:status]}"
          @registration.update(completed: true) if registration_params[:status] == "Completed"
          @registration.update(completed: false) if registration_params[:status] == "Payment Completed"
          @registration.update(completed: false) if registration_params[:status] == "Payment Pending"
          format.json { render json: { status: :ok, message: "Registration was successfully updated." } }
          format.html { redirect_to registrations_path, notice: "Registration was successfully updated." }
        else
          Rails.logger.error "Failed to update registration with id: #{params[:id]}, errors: #{@registration.errors.full_messages}"
          format.json { render json: { status: :unprocessable_entity, message: "Failed to update Vishraam registration.", errors: @registration.errors.full_messages } }
        end
      end
    end
  end
  

 

  def destroy 
    @registration = Registration.find(params[:id])
    @batch = @registration.batch
    RegistrationMailer.registration_cancel_user_email(@registration).deliver_later
    RegistrationMailer.registration_cancel_email(@registration).deliver_later

    @registration.update(cancelled: true, status: "Cancelled")
    
    redirect_back fallback_location: root_path, notice: "Registration cancelled successfully"
  end 

  private 

  def registration_params
    params.require(:registration).permit(:substances, :health_conditions, :medication, :lifestyle, :agreement, :terms, :status, :comments, :completed, :cancelled, :duration, :shamanam_duration, :package_id, :batch_id)
  end 

 


end
