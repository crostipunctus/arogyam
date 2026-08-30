require "test_helper"

class VishraamRegistrationTest < ActiveSupport::TestCase
  test "formats the cost for the selected duration" do
    assert_equal "Rs. 18,000", VishraamRegistration.new(duration: "3").formatted_cost
    assert_equal "Rs. 30,000", VishraamRegistration.new(duration: "5").formatted_cost
  end
end
