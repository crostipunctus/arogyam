class ApplicationController < ActionController::Base

  helper_method :current_user_admin?
  helper_method :gallery_index
  helper_method :team_index
  helper_method :announcements
  protect_from_forgery with: :exception

  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_headers, if: -> { request.get? }

  def after_sign_in_path_for(resource_or_scope)

    stored_location_for(resource_or_scope) || super

  end

  private

  def storable_location?

    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?

  end

  def store_user_location!

    store_location_for(:user, request.fullpath)

  end

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
    @team = TeamMember.with_attached_avatar.all 
  end 

  def announcements 
    @announcement = Announcement.all 
  end 

  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:recaptcha_token, :newsletter_subscription])
  end

  def set_cache_headers
    # Only set aggressive caching for static assets served through Rails
    # Never cache HTML pages that contain user authentication state
    if request.format.symbol == :html || request.format.symbol == :turbo_stream
      # No caching for HTML pages - they contain dynamic user-specific content
      response.headers["Cache-Control"] = "no-store, must-revalidate"
    else
      # Cache other formats (CSS, JS, JSON, etc.) - though these are typically served by web server
      response.headers["Cache-Control"] = "public, max-age=31536000"
      response.headers["Expires"] = 1.year.from_now.to_formatted_s(:rfc822)
    end
  end

 

end
