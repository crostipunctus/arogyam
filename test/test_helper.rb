ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # The suite is small enough to run reliably in one process by default. CI can
  # opt into parallel execution with PARALLEL_WORKERS when its database and
  # local socket environment support it.
  parallelize(workers: ENV.fetch("PARALLEL_WORKERS", 1).to_i)

  Rails.application.routes.default_url_options[:host] = 'test.host'
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
