class RegistrationsController < ApplicationController
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


end
