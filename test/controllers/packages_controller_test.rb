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

  test "programme details retain rich text before and after editable section headings" do
    package = Package.create!(
      name: "Personalised retreat",
      duration: "14 days",
      content: '<p>A quiet introduction.</p><h1>Daily practice</h1><p>Guided <strong>yoga</strong>.</p><h2>Your stay</h2><p>Explore our <a href="/accommodation">accommodation</a>.</p>'
    )

    get programme_path(package)

    assert_response :success
    assert_select ".programme-detail__introduction p", text: "A quiet introduction."
    assert_select "details summary", text: "Daily practice"
    assert_select "details strong", text: "yoga"
    assert_select "details summary", text: "Your stay"
    assert_select "details a[href='/accommodation']", text: "accommodation"
    assert_select ".programme-booking dd", text: "14 days"
    assert_select ".programme-detail__image", count: 0
  end
end
