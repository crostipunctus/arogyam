require "test_helper"
require Rails.root.join("db/migrate/20261007000001_add_mandalam_programme")
require Rails.root.join("db/migrate/20261007000002_fix_mandalam_registration_start_date")
require Rails.root.join("db/migrate/20261125000000_publish_mandalam_with_website_copy")

class SpecialProgrammeTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    AddMandalamProgramme.new.up
    FixMandalamRegistrationStartDate.new.set_mandalam_schedule
    PublishMandalamWithWebsiteCopy.new.up
    @programme = Package.find_by!(slug: "mandalam")
  end

  test "MandalaM is highlighted on both landing pages and links to its full details" do
    3.times { |index| Package.create!(name: "Earlier programme #{index}") }

    [root_path, programmes_path].each do |path|
      get path

      assert_response :success
      assert_select ".special-programme" do
        assert_select "h2", text: "MandalaM"
        assert_select "p", text: /Limited to 10 participants/
        assert_select "dt", text: "Programme dates", count: 0
        assert_select "dd", text: "48 days"
        assert_select "dd", text: "Rs. 1,85,400"
        assert_select "a[href='#{programme_path(@programme)}']", text: "Explore MandalaM"
      end
      assert_select ".programme-card-title", text: "MandalaM", count: 0
    end

    get programme_path(@programme)

    assert_response :success
    assert_select "h1", text: "MandalaM"
    assert_select "img.programme-detail__image"
    assert_select ".programme-booking dt", text: "Programme dates", count: 0
    assert_select ".programme-detail__introduction", text: /treatment start date remains flexible/
    assert_select ".programme-detail__introduction li", text: "Dinacharya (daily routine) guidance"
    assert_select ".programme-detail__disclosure summary", text: "Programme highlights", count: 0
    assert_select ".programme-detail__disclosure summary", text: "One-Day Temple Visit"
    assert_select ".programme-detail__practical", text: /Anyone between 18 and 75/
    assert_select ".programme-detail__practical a[href='tel:+918333981305']"
    assert_select ".programme-content", text: /17 January 2027/, count: 0
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

  test "removing special status returns MandalaM to the normal catalogue" do
    @programme.update!(special: false)

    get programmes_path

    assert_response :success
    assert_select ".special-programme", count: 0
    assert_select ".programme-card-title", text: "MandalaM"
  end

  test "a fixed-date programme uses its date through registration review edit and confirmation" do
    programme = fixed_date_programme
    user = User.create!(email: "fixed@example.com", password: "password123", confirmed_at: Time.current)
    sign_in user

    get new_registration_path(package_id: programme.id)

    assert_response :success
    assert_select "option[selected][value='#{programme.id}']", text: "Fixed-date programme"
    assert_select "input[name='registration[start_date]'][type='hidden'][value='2027-01-17']"
    assert_select "input[name='registration[start_date]'][type='date']", count: 0
    assert_select "[data-registration-start-date-target='fixedDetails']:not([hidden])", text: /17 January 2027/

    post registrations_path, params: {
      registration: {
        package_id: programme.id,
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
    assert_select ".review-value", text: "10"
    assert_select ".review-value", text: "Rs. 10,000"
    assert_select ".review-value", text: /January 17th, 2027/

    get new_registration_path
    assert_response :success
    assert_select "option[selected][value='#{programme.id}']", text: "Fixed-date programme"
    assert_select "input[name='registration[start_date]'][type='hidden'][value='2027-01-17']"

    assert_difference("Registration.count", 1) { post confirm_registrations_path }
    assert_equal Date.new(2027, 1, 17), user.registrations.last.start_date
  end

  test "a fixed-date programme ignores a different submitted date and stays fixed after validation errors" do
    programme = fixed_date_programme
    user = User.create!(email: "fixed@example.com", password: "password123", confirmed_at: Time.current)
    sign_in user

    attributes = {
      package_id: programme.id, start_date: "2027-01-12", lifestyle: "",
      substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1"
    }
    post registrations_path, params: { registration: attributes }

    assert_response :unprocessable_entity
    assert_select "option[selected][value='#{programme.id}']", text: "Fixed-date programme"
    assert_select "input[name='registration[start_date]'][type='hidden'][value='2027-01-17']"

    post registrations_path, params: { registration: attributes.merge(lifestyle: "Active") }
    assert_redirected_to review_registrations_path
    get review_registrations_path
    assert_select ".review-value", text: /January 17th, 2027/
  end

  test "MandalaM keeps the start date picker and the participant's chosen date" do
    fixed_programme = fixed_date_programme
    user = User.create!(email: "mandalam@example.com", password: "password123", confirmed_at: Time.current)
    sign_in user

    get new_registration_path(package_id: @programme.id)
    assert_select "option[selected][value='#{@programme.id}']", text: "MandalaM"
    assert_select "option[value='#{@programme.id}']:not([data-fixed-start-date])"
    assert_select "option[value='#{fixed_programme.id}'][data-fixed-start-date='2027-01-17']"
    assert_select "input[name='registration[start_date]'][type='date']"
    assert_select "[data-registration-start-date-target='fixedDetails'][hidden]"

    post registrations_path, params: {
      registration: {
        package_id: @programme.id, start_date: "2027-02-02", lifestyle: "Active",
        substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1"
      }
    }
    assert_redirected_to review_registrations_path
    get review_registrations_path
    assert_select ".review-value", text: "48"
    assert_select ".review-value", text: "Rs. 1,85,400"
    assert_select ".review-value", text: /February 2nd, 2027/

    assert_difference("Registration.count", 1) { post confirm_registrations_path }
    assert_equal Date.new(2027, 2, 2), user.registrations.last.start_date
  end

  private

  def fixed_date_programme
    Package.create!(
      name: "Fixed-date programme", duration: "10", cost: "10,000",
      dates: "17 January 2027 – 26 January 2027", fixed_start_date: Date.new(2027, 1, 17)
    )
  end
end
