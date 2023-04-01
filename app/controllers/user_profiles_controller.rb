class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions

  def show
    @user = User.find(params[:user_id])
    @profile = @user.user_profile
  end

  def edit 

  end 

  def update 

  end 

  private 

  def check_permissions
    @user = User.find(params[:user_id])
    unless current_user_admin? || current_user == @user
      flash[:alert] = "Unauthorized access! You have to be an admin user or the profile owner!"
      redirect_to root_url
    end
  end
end
