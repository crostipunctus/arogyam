require "application_system_test_case"

class RegistrationStartDateTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1000]

  test "switching programmes shows the appropriate fixed date or date picker" do
    user = User.create!(email: "schedule@example.com", password: "password123", confirmed_at: Time.current)
    fixed_programme = Package.create!(name: "Fixed-date programme", fixed_start_date: Date.new(2027, 1, 17), dates: "17 January 2027 – 6 March 2027")
    Package.create!(name: "Flexible programme")
    sign_in user

    visit new_registration_path(package_id: fixed_programme.id)

    assert_no_selector "input[type='date'][name='registration[start_date]']"
    assert_selector "[data-registration-start-date-target='fixedDetails']", text: "17 January 2027"

    select "Flexible programme", from: "package-select"

    assert_selector "input[type='date'][name='registration[start_date]']"
    assert_equal "", find("#registration_start_date").value
    assert_no_selector "[data-registration-start-date-target='fixedDetails']"
    fill_in "Start Date", with: "2027-02-02"

    select "Fixed-date programme", from: "package-select"

    assert_no_selector "input[type='date'][name='registration[start_date]']"
    assert_selector "[data-registration-start-date-target='fixedDetails']", text: "6 March 2027"
    assert_equal "2027-01-17", find("#registration_start_date", visible: :all).value
  end
end
