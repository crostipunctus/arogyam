class ApplicationController < ActionController::Base
  helper_method :current_user_admin?
  before_action :current_user_admin?

  def current_user_admin? 
    current_user && current_user.admin? 
  end 
 

end
