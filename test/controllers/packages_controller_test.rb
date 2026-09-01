require "test_helper"

class PackagesControllerTest < ActionDispatch::IntegrationTest
  test "unpublished programmes are excluded from the catalogue" do
    published_package = Package.create!(name: "Published programme", short_description: "Visible")
    unpublished_package = Package.create!(name: "SoukhyaM", short_description: "Hidden", published: false)

    get programmes_path

    assert_response :success
    assert_select "h5", text: published_package.name
    assert_select "h5", text: unpublished_package.name, count: 0
  end

  test "an unpublished programme page is not publicly available" do
    unpublished_package = Package.create!(name: "SoukhyaM", published: false)

    get programme_path(unpublished_package)

    assert_response :not_found
  end
end
