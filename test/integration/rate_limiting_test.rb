require "test_helper"

class RateLimitingTest < ActionDispatch::IntegrationTest
  setup do
    ApplicationController::RATE_LIMIT_STORE.clear
  end

  teardown do
    ApplicationController::RATE_LIMIT_STORE.clear
  end

  test "limits repeated sign-in attempts from one address" do
    10.times do
      post user_session_path,
        params: { user: { email: "missing@example.com", password: "incorrect" } },
        headers: { "REMOTE_ADDR" => "192.0.2.10" }

      assert_not_equal 429, response.status
    end

    post user_session_path,
      params: { user: { email: "missing@example.com", password: "incorrect" } },
      headers: { "REMOTE_ADDR" => "192.0.2.10" }

    assert_response :too_many_requests
    assert_equal "60", response.headers["Retry-After"]
  end

  test "limits repeated public form submissions from one address" do
    donation_params = {
      donation_request: {
        category: "general",
        amount: "500",
        payment_method: "online"
      },
      recaptcha_token: { malformed: "token" }
    }

    15.times do
      post donate_path,
        params: donation_params,
        headers: { "REMOTE_ADDR" => "192.0.2.20" }

      assert_response :unprocessable_entity
    end

    post donate_path,
      params: donation_params,
      headers: { "REMOTE_ADDR" => "192.0.2.20" }

    assert_response :too_many_requests
    assert_equal "60", response.headers["Retry-After"]
  end
end
