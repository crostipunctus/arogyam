source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record


# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 7.2", ">= 7.2.1"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# RailsAdmin's Sprockets asset source compiles the engine's SCSS at runtime.
gem "sassc-rails", "~> 2.1"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.4"

gem 'swiper-rails'

gem "simple_calendar", "~> 2.4"

gem 'carmen'


# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "recaptcha"

gem "bootstrap_form", "~> 5.1"

gem 'devise', '~> 5.0', '>= 5.0.4'

gem "responders"

gem "aws-sdk-s3"

gem 'jquery-rails'

gem 'fancybox-rails'

gem 'mail_form'

gem 'gibbon'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem 'sidekiq', '~> 7.3'
gem 'connection_pool', '< 3'


gem 'caxlsx', '~> 3.0'

gem 'caxlsx_rails'

gem 'rails_admin', '~> 3.3'

gem 'kaminari'

gem 'ruby-vips', '~> 2.1', '>= 2.1.4'

gem "sentry-ruby"

gem "sentry-rails"

gem 'meta-tags'
gem 'sitemap_generator'

gem 'faker'

gem 'rest-client'

gem 'activerecord-session_store', '~> 2.3'


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "sqlite3", "~> 2.9", ">= 2.9.5"
end

group :production do 
  gem 'pg'
end 

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'capistrano', '~> 3.17'
  gem 'capistrano-rails', '~> 1.6', '>= 1.6.2'
  gem 'capistrano-passenger'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'ed25519', '~> 1.3'
  gem 'bcrypt_pbkdf', '~> 1.1'
  gem 'capistrano-sidekiq'
  gem 'net-ssh', '~> 7.3.0'
  gem 'rbnacl', '~> 7.1'
gem 'rbnacl-libsodium'
 


 
 
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem "minitest", "< 6"
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver", ">= 4.14"
end

gem 'dotenv-rails', groups: [:development, :test]

