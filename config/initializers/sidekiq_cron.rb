Sidekiq::Cron.configure do |config|
  config.enabled = Rails.env.production?
  config.cron_schedule_file = Rails.root.join("config/sidekiq_schedule.yml").to_s
end
