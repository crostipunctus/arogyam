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
    @vishraam_registration.destroy

    redirect_to user_profile_path(current_user), notice: "Vishram registration cancelled"
  end

  def pdf 
    @vishraam_registrations = VishraamRegistration.all

    html = render_to_string(inline: render_table)

    kit = PDFKit.new(html)
    file = kit.to_file('vishram_registrations_table.pdf')

    send_file(
      file.path,
      filename: 'vishram_registrations_table.pdf',
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end

  private 

  def vishraam_registration_params 
    params.require(:vishraam_registration).permit(:date, :duration, :substances, :health_conditions, :medication, :lifestyle, :agreement, :terms, :status)
  end 

  def render_table
    <<-HTML
    <h1>Vishram Registrations</h1>
    <table style="width: 100%; font-size: 12pt; border-collapse: collapse; font-family: Arial, sans-serif;">
    <thead>
        <tr>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Name</th>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Date</th>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Duration</th>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Email</th>
            <!-- Add other column headers here -->
        </tr>
    </thead>
    <tbody>
        <% @vishraam_registrations.each do |registration| %>
            <tr style="background-color: <%= cycle('#f0f0f0', '#ffffff') %>;">
            <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= user_full_name(registration.user) %></td>
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.date %></td>
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.duration %></td>

                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= registration.user.email %></td>
                <!-- Add other columns here -->
            </tr>
        <% end %>
    </tbody>
</table>
    HTML
  end

end