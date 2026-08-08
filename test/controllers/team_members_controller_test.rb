require "test_helper"

class TeamMembersControllerTest < ActionDispatch::IntegrationTest
  test "show remains public" do
    get team_member_url(id: 1)
    assert_response :success
  end

  test "guests cannot access team management" do
    get team_members_url

    assert_redirected_to new_user_session_path
  end
end
