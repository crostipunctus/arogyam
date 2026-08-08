require "net/http"

module Donations
  class CreatePayment
    DEFAULT_API_URL = "https://api.satsang-foundation.org/v1/donations".freeze
    PAYMENT_HOST = "donate.satsang-foundation.org".freeze

    Result = Struct.new(:payment_url, :message, :errors, keyword_init: true) do
      def success?
        payment_url.present?
      end
    end

    def initialize(donation:, api_key:, transport: nil)
      @donation = donation
      @api_key = api_key
      @transport = transport || method(:post_request)
    end

    def call
      return failure("Online donations are temporarily unavailable.") if api_key.blank?

      response = transport.call(api_uri, request)
      parsed_response = JSON.parse(response.body)

      return failure("Unable to process donation.") unless parsed_response.is_a?(Hash)
      return api_failure(parsed_response) unless response.code.to_i.between?(200, 299)
      return api_failure(parsed_response) unless parsed_response["status"] == "success"

      payment_url = verified_payment_url(parsed_response.dig("data", "payment_url"))
      return failure("Payment URL not received.") unless payment_url

      Result.new(payment_url: payment_url, errors: {})
    rescue JSON::ParserError, TypeError
      failure("Unable to process donation.")
    rescue URI::InvalidURIError
      Rails.logger.error("[Donation API] Invalid API URL configuration")
      failure("Online donations are temporarily unavailable.")
    rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, SystemCallError => error
      Rails.logger.error("[Donation API] #{error.class}: #{error.message}")
      failure("Unable to connect to the payment server. Please try again.")
    end

    private

    attr_reader :donation, :api_key, :transport

    def api_uri
      uri = URI.parse(ENV.fetch("DONATION_API_URL", DEFAULT_API_URL))
      return uri if uri.is_a?(URI::HTTPS) && uri.host == "api.satsang-foundation.org" && uri.port == 443

      raise URI::InvalidURIError, "Donation API URL is not allowlisted"
    end

    def request
      Net::HTTP::Post.new(api_uri).tap do |request|
        request["Content-Type"] = "application/json"
        request["Accept"] = "application/json"
        request["X-API-Key"] = api_key
        request.body = JSON.generate(donation.api_payload)
      end
    end

    def post_request(uri, request)
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: true,
        open_timeout: 5,
        read_timeout: 30,
        write_timeout: 10
      ) { |http| http.request(request) }
    end

    def verified_payment_url(value)
      uri = URI.parse(value.to_s)
      return unless uri.is_a?(URI::HTTPS)
      return unless uri.host == PAYMENT_HOST && uri.port == 443
      return unless uri.path.start_with?("/donate/")

      uri.to_s
    rescue URI::InvalidURIError
      nil
    end

    def api_failure(parsed_response)
      failure(
        parsed_response["message"].presence || "Unable to process donation.",
        normalized_errors(parsed_response["errors"])
      )
    end

    def normalized_errors(errors)
      return {} unless errors.is_a?(Hash)

      errors.slice("sub_cause", "amount", "payment_method", "full_name", "email", "mobile", "pan_no", "message")
            .transform_values { |message| message.to_s.first(200) }
    end

    def failure(message, errors = {})
      Result.new(message: message.to_s.first(200), errors: errors)
    end
  end
end
