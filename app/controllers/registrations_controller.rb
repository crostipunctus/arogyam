class RegistrationsController < ApplicationController
  require 'pdfkit'
  before_action :authenticate_user! 
  before_action :require_admin, only: [:index, :edit, :update ]
  def index 
    @registrations = Registration.all 
    @vishraam_registrations = VishraamRegistration.all
    
  end

  def export_batch
    @registrations = Registration.includes(user: :user_profile).all

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
    
    @registration = Registration.new(batch_id: params[:batch_id])

  end 

  def create
    
    if current_user.user_profile
      if Registration.exists?(user: current_user, batch_id: params[:batch_id])
        redirect_to batches_path, alert: "You have already registered for this batch"
      else
      
        @batch = Batch.find(params[:registration][:batch_id])
      
        @registration = Registration.new(registration_params)
        @registration.user = current_user
        @registration.batch = @batch
        if @registration.save
          RegistrationMailer.registration_email(@registration).deliver_later
          
          redirect_to batches_path, notice: "Registered successfully"
        else
       
          render :new, status: :unprocessable_entity 
        end
      end
    else  
      redirect_to new_user_profile_path(user_id: current_user.id), alert: "Please complete your profile before registering for a batch"
    end 
  end
  
  def pdf 
    @registrations = Registration.all

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

  def edit  

  end 

  def update 
    @registration = Registration.find(params[:id])
    respond_to do |format|
      if @registration.update_column(:status, registration_params[:status])
        format.json { render json: { status: :ok, message: "Registration was successfully updated." } }
      else
        Rails.logger.error "Failed to update registration with id: #{params[:id]}, errors: #{@registration.errors.full_messages}"
        format.json { render json: { status: :unprocessable_entity, message: "Failed to update Vishraam registration.", errors: @registration.errors.full_messages } }
      end
    end
  end 

  def destroy 
    @registration = Registration.find(params[:id])
    @registration.destroy    
    
    redirect_to batches_path, alert: "Batch registration cancelled"
  end 

  private 

  def registration_params
    params.require(:registration).permit(:batch_id, :package_id, :user_id, :substances, :health_conditions, :medication, :lifestyle, :agreement, :terms, :status)
  end 

  def render_table
    <<-HTML
    <table style="width: 100%; font-size: 12pt; border-collapse: collapse; font-family: Arial, sans-serif;">
    <thead>
        <tr>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Batch</th>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Name</th>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Email</th>
            <!-- Add other column headers here -->
        </tr>
    </thead>
    <tbody>
        <% @registrations.each do |registration| %>
            <tr style="background-color: <%= cycle('#f0f0f0', '#ffffff') %>;">
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= batch_date_range(registration.batch) %></td>
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= user_full_name(registration.user) %></td>
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.user.email %></td>
                <!-- Add other columns here -->
            </tr>
        <% end %>
    </tbody>
</table>
    HTML
  end


end
