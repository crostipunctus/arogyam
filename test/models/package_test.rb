require "test_helper"

class PackageTest < ActiveSupport::TestCase
  test "formats the selected ShamanaM duration cost" do
    package = Package.new(name: "ShamanaM", cost: "41,000/- or Rs. 82,000/-")

    assert_equal "Rs. 41,000/-", package.formatted_cost(duration: "7")
    assert_equal "Rs. 82,000/-", package.formatted_cost(duration: "14")
  end

  test "formats the selected VishraM duration cost" do
    package = Package.new(name: "VishraM", cost: "18,000 or Rs. 30,000")

    assert_equal "Rs. 18,000", package.formatted_cost(duration: "3")
    assert_equal "Rs. 30,000", package.formatted_cost(duration: "5")
  end

  test "formats the stored cost when no duration-specific cost applies" do
    package = Package.new(name: "ShodhanaM", cost: "1,20,000/-")

    assert_equal "Rs. 1,20,000/-", package.formatted_cost
  end
end
