require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "guests cannot view a user profile" do
    get user_profile_url(user_id: 1)

    assert_redirected_to new_user_session_path
  end
end
