class ProfilesController < ApplicationController
  before_action :require_admin

  def show
    @user = current_user
  end
end
