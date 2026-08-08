require "digest"

module Donations
  class SubmissionThrottle
    LIMIT = 5
    WINDOW = 10.minutes

    def initialize(identifier:, limit: LIMIT, cache: Rails.cache)
      @identifier = identifier
      @limit = limit
      @cache = cache
    end

    def allowed?
      cache.write(cache_key, 0, expires_in: WINDOW, unless_exist: true)
      attempts = cache.increment(cache_key, 1)
      attempts.nil? || attempts <= limit
    rescue StandardError => error
      Rails.logger.warn("[Donation throttle] #{error.class}: #{error.message}")
      true
    end

    private

    attr_reader :identifier, :limit, :cache

    def cache_key
      digest = Digest::SHA256.hexdigest(identifier)
      "donations:submissions:#{digest}"
    end
  end
end
