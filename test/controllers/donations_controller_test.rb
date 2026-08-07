require "test_helper"

class DonationsControllerTest < ActionDispatch::IntegrationTest
  test "donation planner is publicly available without accepting payments" do
    get donate_path

    assert_response :success
    assert_select "h1", "Help wellbeing take root"
    assert_select "button[disabled]", text: /Continue to secure payment/
    assert_select "form", count: 0
  end
end
