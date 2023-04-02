class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions
  before_action :set_user

  def show
    @profile = @user.user_profile
  end

  def edit 
    @profile = @user.user_profile
  end 

  def update 
    @profile = @user.user_profile
    @profile.update(profile_params)

    if @profile.save 
      redirect_to user_profile_path(@user)
    else  
      render :edit, status: :unprocessable_entity
    end
  end 

  def new 
    if @user.user_profile.present? 
      redirect_to user_profile_path(@user), notice: "Your profile is already completed!"
    else  
      @profile = UserProfile.new
    end 
  end 

  def create 
    @profile = UserProfile.create(profile_params)
    @profile.user = @user 

    if @profile.save 
      redirect_to user_profile_path(@user)
    else  
      render :new, status: :unprocessable_entity
    end 

  end 

  private 

  def set_user  
    @user = User.find(params[:user_id])
  end 

  def check_permissions
    @user = User.find(params[:user_id])
    unless current_user_admin? || current_user == @user
      flash[:alert] = "Unauthorized access! You have to be an admin user or the profile owner!"
      redirect_to root_url
    end
  end

  def profile_params 
    params.require(:user_profile).permit(:gender, :date_of_birth, :phone_number, :address, :city, :zip, :country, :alternate_phone_number, :doctor_contact_details, :nationality, :marital_status, :occupation)
  end 
end
