class ApplicationController < ActionController::Base

  helper_method :current_user_admin?
  helper_method :gallery_index
  helper_method :team_index
  helper_method :announcements
  

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access! You have to be an admin user!"
    end
  end

  def current_user_admin? 
    current_user && current_user.admin? 
  end 
 
  def gallery_index 
    @gallery = Gallery.first
  end 



  def team_index 
    @team = TeamMember.all 
  end 

  def announcements 
    @announcement = Announcement.all 
  end 
 

end
