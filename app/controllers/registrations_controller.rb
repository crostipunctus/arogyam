class RegistrationsController < ApplicationController
  require 'pdfkit'
  before_action :authenticate_user!, only: [:create]
  before_action :require_admin, only: [:index, :edit, :update,  :destroy]
  def index 
    @registrations = Registration.all 

  end

  def new 

  end 

  def create
    @batch = Batch.find(params[:batch_id])
  
    if Registration.exists?(user: current_user, batch: @batch)
      redirect_to batches_path, alert: "You have already registered for this batch"
    else
      @registration = current_user.registrations.new(batch: @batch)
      if @registration.save
        redirect_to batches_path, notice: "Registered successfully"
      else
        redirect_to root_path, status: :unprocessable_entity
      end
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

  end 

  def destroy 

  end 

  private 

  def registration_params
    params.require(:registration).permit(:batch_id, :user_id)
  end 

  def render_table
    <<-HTML
      <table>
        <thead>
          <tr>
            <th>Batch</th>
            <th>User</th>
            <!-- Add other column headers here -->
          </tr>
        </thead>
        <tbody>
          <% @registrations.each do |registration| %>
            <tr>
              <td><%= registration.batch.name %></td>
              <td><%= registration.user.email %></td>
              <!-- Add other columns here -->
            </tr>
          <% end %>
        </tbody>
      </table>
    HTML
  end


end
