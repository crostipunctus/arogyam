require "test_helper"

class TeamMemberTest < ActiveSupport::TestCase
  test "position maps to the legacy role column" do
    team_member = TeamMember.new(position: "Ayurveda Practitioner")

    assert_equal "Ayurveda Practitioner", team_member.role
    assert_equal "Ayurveda Practitioner", team_member.position
  end
end
