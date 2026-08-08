class ApplicationController < ActionController::Base

  helper_method :current_user_admin?
  helper_method :gallery_index
  helper_method :team_index
  helper_method :announcements
  helper_method :testimonials_preview
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
    @gallery = Gallery.with_attached_images.first
  end



  def team_index 
    @team = TeamMember.with_attached_avatar.all 
  end 

  def announcements
    @announcement = Announcement.all
  end

  def testimonials_preview
    @testimonials_preview ||= Testimonial.limit(2)
  end 

  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:recaptcha_token, :newsletter_subscription])
  end

  def set_cache_headers
    response.headers["Cache-Control"] = if user_signed_in?
      "private, no-store"
    else
      "private, max-age=0, must-revalidate"
    end
    response.headers.delete("Expires")
  end

 

end
