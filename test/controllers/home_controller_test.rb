require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "anonymous HTML responses are not publicly cached" do
    get root_url

    assert_response :success
    assert_select "script[src='https://www.google.com/recaptcha/api.js']", count: 1
    assert_select "script[src^='https://www.google.com/recaptcha/api.js?render=']", count: 0
    assert_includes response.headers["Cache-Control"], "private"
    assert_includes response.headers["Cache-Control"], "max-age=0"
    assert_includes response.headers["Cache-Control"], "must-revalidate"
    assert_nil response.headers["Expires"]
  end

  test "shows cookie choices without loading Google Analytics before consent" do
    get root_url

    assert_response :success
    assert_select "body[data-controller~='cookie-consent']"
    assert_select "section[data-cookie-consent-target='banner'][hidden]"
    assert_select "button[data-action='cookie-consent#reject']", text: /Use essential cookies only/
    assert_select "button[data-action='cookie-consent#accept']", text: /Accept all cookies/
    assert_select "script[src^='https://www.googletagmanager.com/gtag/js']", count: 0
    assert_includes response.body, 'analytics_storage: analyticsGranted ? "granted" : "denied"'
    assert_select "a[href='#{cookie_policy_path}']", minimum: 1
    assert_select "button[data-action='cookie-consent#open']", minimum: 1
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
    assert_includes policy, "form-action 'self' https://donate.satsang-foundation.org"
    assert_includes policy, "frame-ancestors 'self'"
    assert_includes response.headers["Feature-Policy"], "camera 'none'"

    nonce = policy[/\A.*'nonce-([^']+)'/, 1]
    assert nonce.present?
    assert_includes response.body, %(nonce="#{nonce}")
  end
end
