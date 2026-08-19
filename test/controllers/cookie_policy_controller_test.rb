require "test_helper"

class CookiePolicyControllerTest < ActionDispatch::IntegrationTest
  test "shows cookie categories and preference controls" do
    get cookie_policy_url

    assert_response :success
    assert_select "h1", text: "Cookie policy"
    assert_select "code", text: "_arogyam_session"
    assert_select "button[data-action='cookie-consent#open']", text: /Open cookie settings/
    assert_select "a[href='#{privacy_policy_path}']", text: "Privacy Policy"
  end
end
