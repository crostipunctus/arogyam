class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  # Ensure view paths are always resolved, even when running in Sidekiq
  prepend_view_path Rails.root.join("app", "views")
end
