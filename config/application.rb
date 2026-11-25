require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Arogyam
  class Application < Rails::Application
    # Use the framework defaults for the version this application runs on.
    config.load_defaults 8.1

    config.active_job.queue_adapter = :sidekiq
    config.active_storage.variant_processor = :mini_magick
    # Our named variants set JPEG quality with `saver: { quality: ... }`.
    # Active Storage's ImageMagick transformer rejects `saver` unless allowed.
    config.active_storage.supported_image_processing_methods = %w[saver]

    config.time_zone = 'Asia/Kolkata'

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
