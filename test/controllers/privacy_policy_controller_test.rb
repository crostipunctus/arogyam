require "test_helper"

class PrivacyPolicyControllerTest < ActionDispatch::IntegrationTest
  test "shows privacy and cookie information" do
    get privacy_policy_url

    assert_response :success
    assert_select "h1", text: "Privacy policy"
    assert_select "a[href='#{cookie_policy_path}']", text: "Cookie Policy"
  end
end
