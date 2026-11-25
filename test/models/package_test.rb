require "test_helper"

class PackageTest < ActiveSupport::TestCase
  test "published excludes unpublished programmes" do
    published_package = Package.create!(name: "Published programme")
    unpublished_package = Package.create!(name: "Unpublished programme", published: false)

    assert_includes Package.published, published_package
    assert_not_includes Package.published, unpublished_package
  end

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

  # Production generates variants inline while rendering programme pages, so a
  # rejected transformation would turn into a page error.
  test "generates the card and hero image variants" do
    package = Package.create!(name: "Imaged programme")
    package.package_image.attach(io: Rails.root.join("db/data/mandalam-nasya-treatment.jpg").open("rb"),
                                 filename: "programme.jpg", content_type: "image/jpeg")

    hero = package.package_image.variant(:hero).processed.image.blob
    hero.analyze

    assert_equal [1350, 900], hero.metadata.values_at("width", "height")
    assert package.package_image.variant(:card).processed.key.present?
  end

  test "formats the stored cost when no duration-specific cost applies" do
    package = Package.new(name: "ShodhanaM", cost: "1,20,000/-")

    assert_equal "Rs. 1,20,000/-", package.formatted_cost
  end
end
