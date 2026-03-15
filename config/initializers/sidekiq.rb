Sidekiq.configure_server do |config|
  # Ensure all mailer view paths are resolved on boot,
  # preventing MissingTemplate errors when Sidekiq's template
  # resolver cache doesn't include the app's view paths.
  config.on(:startup) do
    ActionMailer::Base.view_paths = ActionMailer::Base.view_paths
    ActionController::Base.view_paths = ActionController::Base.view_paths
  end
end
