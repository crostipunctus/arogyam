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
      @registrations = Registration.where(cancelled: false, completed: false)
                               .where('start_date >= ? OR start_date IS NULL', Date.current)  # Changed from Date.today
                               .order(start_date: :asc, created_at: :desc)  # Added ordering
                               .page(params[:page])
                               .per(10)
    when 'payment_complete'
      @registrations = Registration.where(status: 'Payment Completed').page(params[:page]).per(10)
    when 'payment_pending'
      @registrations = Registration.where(status: 'Payment Pending').page(params[:page]).per(10)
    else
      @registrations = Registration.where(cancelled: false, completed: false)
                               .where('start_date >= ? OR start_date IS NULL', Date.current)  # Changed from created_at comparison
                               .order(start_date: :asc, created_at: :desc)  # Added ordering
                               .page(params[:page])
                               .per(10)
    end
    @vishraam_registrations = VishraamRegistration.where("date > ?", Date.today)
    .where(cancelled: false, completed: false)
    .page(params[:page])
    @online_consultations = OnlineConsultation.all
    
    
  end

  def export_batch
    @registrations = Registration.includes(user: :user_profile)
                               .order(created_at: :desc)
  
    respond_to do |format|
      format.xlsx { 
        render xlsx: 'registrations', 
        filename: "registrations-#{Date.today.strftime("%Y%m%d")}.xlsx" 
      }
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
    Rails.logger.debug "Starting new registration action"
    @registration = Registration.new  # Always initialize
    Rails.logger.debug "Initialized new registration object"
  
    if session[:registration_params]
      Rails.logger.debug "Found registration params in session: #{session[:registration_params]}"
      @registration = Registration.new(session[:registration_params])
      Rails.logger.debug "Created registration from session params"
    end
    
    if params[:package_id] && Package.exists?(params[:package_id])
      Rails.logger.debug "Package ID from params: #{params[:package_id]}"
      @selected_package_id = params[:package_id].to_i
      Rails.logger.debug "Set selected_package_id to: #{@selected_package_id}"
    else
      Rails.logger.debug "No valid package_id found in params"
      @selected_package_id = nil
    end
  end
  
  def create
    Rails.logger.debug "Starting create registration action"
    Rails.logger.debug "Registration params received: #{registration_params}"
    
    if has_active_registration?(current_user)  # Use the helper method here
      Rails.logger.debug "User already has an active registration"
      flash.now[:alert] = "Please cancel your current registration or complete payment for it before booking another programme."
      @registration = Registration.new(registration_params)
      @selected_package_id = params[:registration][:package_id]
      render :new, status: :unprocessable_entity
    else
      Rails.logger.debug "Finding package with ID: #{params[:registration][:package_id]}"
      @package = Package.find(params[:registration][:package_id])
      Rails.logger.debug "Found package: #{@package.inspect}"
      
      @registration = Registration.new(registration_params)
      @registration.user = current_user
      @registration.package = @package
      
      Rails.logger.debug "Setting duration based on package type"
      if @package.name == 'VishraM'
        @registration.duration = registration_params[:duration]
        Rails.logger.debug "Set VishraM duration to: #{@registration.duration}"
      else
        @registration.duration = @package.duration
        Rails.logger.debug "Set fixed package duration to: #{@registration.duration}"
      end
  
      if @registration.valid?
        Rails.logger.debug "Registration is valid, saving to session"
        session[:registration_params] = @registration.attributes
        redirect_to review_registrations_path
      else
        Rails.logger.error "Registration validation failed: #{@registration.errors.full_messages}"
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
      redirect_to root_path, notice: "Registered successfully"
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
   
    RegistrationMailer.registration_cancel_user_email(@registration).deliver_later
    RegistrationMailer.registration_cancel_email(@registration).deliver_later

    @registration.update(cancelled: true, status: "Cancelled")
    
    redirect_back fallback_location: root_path, notice: "Registration cancelled successfully"
  end 


  def pdf
    @registrations = Registration.where(cancelled: false)
                               .includes(user: :user_profile)
                               .order(created_at: :desc)
  
    respond_to do |format|
      format.pdf do
        html = render_to_string(inline: render_table)
        kit = PDFKit.new(html)
        file = kit.to_file('registrations_table.pdf')
        send_file(
          file.path,
          filename: 'registrations_table.pdf',
          type: 'application/pdf',
          disposition: 'attachment'
        )
      end
      
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="registrations.xlsx"'
        render xlsx: 'registrations'  # Changed from 'pdf' to 'registrations' to match your template name
      end
    end
  end


  private 

  def registration_params
    params.require(:registration).permit(:substances, :health_conditions, :medication, :lifestyle, :agreement, :terms, :status, :comments, :completed, :cancelled, :duration, :start_date, :shamanam_duration, :package_id)
  end 


def render_table
  <<-HTML
  <h1>Registrations List</h1>
  <table style="width: 100%; font-size: 12pt; border-collapse: collapse; font-family: Arial, sans-serif;">
    <thead>
      <tr>
        <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Name</th>
        <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Email</th>
        <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Programme</th>
        <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Start Date</th>
        <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Status</th>
      </tr>
    </thead>
    <tbody>
      <% @registrations.each do |registration| %>
        <tr style="background-color: <%= cycle('#ccffd9', '#e6ffec') %>;">
          <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= user_full_name(registration.user) %></td>
          <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.user.email %></td>
          <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.package.name %></td>
          <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.start_date.strftime("%d-%m-%Y") %></td>
          <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.status %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
  HTML
end

 


end
