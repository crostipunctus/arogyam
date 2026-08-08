require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "anonymous HTML responses are not publicly cached" do
    get root_url

    assert_response :success
    assert_includes response.headers["Cache-Control"], "private"
    assert_includes response.headers["Cache-Control"], "max-age=0"
    assert_includes response.headers["Cache-Control"], "must-revalidate"
    assert_nil response.headers["Expires"]
  end

  test "authenticated HTML responses are never stored" do
    sign_in User.create!(
      email: "cache-test@example.com",
      password: "password123",
      privacy_policy: "1",
      confirmed_at: Time.current
    )

    get root_url

    assert_response :success
    assert_equal "private, no-store", response.headers["Cache-Control"]
  end

  test "responses include restrictive browser security policies" do
    get root_url

    policy = response.headers["Content-Security-Policy"]
    assert_includes policy, "default-src 'self'"
    assert_includes policy, "object-src 'none'"
    assert_includes policy, "frame-ancestors 'self'"
    assert_includes response.headers["Feature-Policy"], "camera 'none'"

    nonce = policy[/\A.*'nonce-([^']+)'/, 1]
    assert nonce.present?
    assert_includes response.body, %(nonce="#{nonce}")
  end
end
