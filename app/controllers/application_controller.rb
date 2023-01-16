class ApplicationController < ActionController::Base
  helper_method :current_user_admin?
  

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access!"
    end
  end

  def current_user_admin? 
    current_user && current_user.admin? 
  end 
 

end
