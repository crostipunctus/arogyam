require "test_helper"
require Rails.root.join("db/migrate/20261007000001_add_mandalam_programme")

class SpecialProgrammeTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    AddMandalamProgramme.new.up
    @programme = Package.find_by!(slug: "mandalam")
  end

  test "Mandalam is highlighted on both landing pages and links to its full details" do
    3.times { |index| Package.create!(name: "Earlier programme #{index}") }

    [root_path, programmes_path].each do |path|
      get path

      assert_response :success
      assert_select ".special-programme" do
        assert_select "h2", text: "Mandalam"
        assert_select "p", text: /Limited to 10 participants/
        assert_select "dd", text: "17 January 2027 – 6 March 2027"
        assert_select "dd", text: "48 days"
        assert_select "dd", text: "Rs. 1,85,400"
        assert_select "a[href='#{programme_path(@programme)}']", text: "Explore Mandalam"
      end
      assert_select ".programme-card-title", text: "Mandalam", count: 0
    end

    get programme_path(@programme)

    assert_response :success
    assert_select "h1", text: "Mandalam"
    assert_select ".programme-content", text: /12 and 17 January 2027/
    assert_select ".programme-content", text: /14-day Ayurvedic Panchakarma/
    assert_select ".programme-content", text: /18–75 years/
    assert_select ".programme-content", text: /health parameter tests advised by the Vaidya/
    assert_select "a[href='#{new_user_session_path}']", text: /Sign In to Register/
  end

  test "unpublishing removes the special programme from both pages" do
    @programme.update!(published: false)

    [root_path, programmes_path].each do |path|
      get path

      assert_response :success
      assert_select ".special-programme", count: 0
      assert_select "a[href='#{programme_path(@programme)}']", count: 0
    end
  end

  test "removing special status returns Mandalam to the normal catalogue" do
    @programme.update!(special: false)

    get programmes_path

    assert_response :success
    assert_select ".special-programme", count: 0
    assert_select ".programme-card-title", text: "Mandalam"
  end

  test "Mandalam can be selected and reviewed through the existing registration flow" do
    user = User.create!(email: "mandalam@example.com", password: "password123", confirmed_at: Time.current)
    sign_in user

    get new_registration_path(package_id: @programme.id)

    assert_response :success
    assert_select "option[selected][value='#{@programme.id}']", text: "Mandalam"

    post registrations_path, params: {
      registration: {
        package_id: @programme.id,
        start_date: "2027-01-17",
        lifestyle: "Active",
        substances: "None",
        health_conditions: "None",
        medication: "None",
        agreement: "1",
        terms: "1"
      }
    }

    assert_redirected_to review_registrations_path

    get review_registrations_path

    assert_response :success
    assert_select ".review-value", text: "48"
    assert_select ".review-value", text: "Rs. 1,85,400"
  end
end
