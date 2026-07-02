class ApplicationMailer < ActionMailer::Base
  default from: "ArogyaM <admin@arogyam.life>"
  layout "mailer"

  # Ensure view paths are always resolved, even when running in Sidekiq.
  # Using a before_action instead of class-level prepend_view_path so the
  # path is set on every delivery, not just once at class load time.
  before_action :ensure_view_path

  private

  def ensure_view_path
    prepend_view_path Rails.root.join("app", "views")
  end
end
