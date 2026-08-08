require "test_helper"

class Donations::SubmissionThrottleTest < ActiveSupport::TestCase
  test "allows only the configured number of attempts within the window" do
    cache = ActiveSupport::Cache::MemoryStore.new
    throttle = Donations::SubmissionThrottle.new(identifier: "session:donor", cache: cache)

    Donations::SubmissionThrottle::LIMIT.times do
      assert throttle.allowed?
    end

    assert_not throttle.allowed?
  ensure
    cache&.clear
  end

  test "does not store the raw donor identifier in the cache key" do
    cache = ActiveSupport::Cache::MemoryStore.new
    identifier = "session:anita@example.com:9876543210"

    Donations::SubmissionThrottle.new(identifier: identifier, cache: cache).allowed?

    assert cache.instance_variable_get(:@data).keys.none? { |key| key.include?(identifier) }
  ensure
    cache&.clear
  end

  test "supports a stricter or broader limit for different identifiers" do
    cache = ActiveSupport::Cache::MemoryStore.new
    throttle = Donations::SubmissionThrottle.new(identifier: "ip:127.0.0.1", limit: 2, cache: cache)

    assert throttle.allowed?
    assert throttle.allowed?
    assert_not throttle.allowed?
  ensure
    cache&.clear
  end
end
