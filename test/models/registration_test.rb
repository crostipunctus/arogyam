require "test_helper"

class RegistrationTest < ActiveSupport::TestCase
  test "setting a fixed programme date does not change existing registrations" do
    user = User.create!(email: "existing@example.com", password: "password123", confirmed_at: Time.current)
    programme = Package.create!(name: "Mandalam")
    registration = Registration.create!(
      user: user, package: programme, start_date: Date.new(2027, 1, 12),
      lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None",
      agreement: "1", terms: "1"
    )

    programme.update!(fixed_start_date: Date.new(2027, 1, 17))
    registration.update!(comments: "Existing booking")

    assert_equal Date.new(2027, 1, 12), registration.reload.start_date
  end

  test "an unpublished programme cannot accept a new registration" do
    registration = Registration.new(
      package: Package.new(name: "SoukhyaM", published: false),
      start_date: Date.current
    )

    registration.valid?

    assert_includes registration.errors[:package], "is no longer available"
  end

  test "ShamanaM uses the selected duration in its programme label" do
    registration = Registration.new(
      package: Package.new(name: "ShamanaM", duration: "7 or 14 days"),
      duration: "7 or 14 days",
      shamanam_duration: "14"
    )

    assert_equal "14", registration.selected_duration
    assert_equal "ShamanaM — 14 days", registration.programme_label
  end

  test "ShamanaM only accepts a 7-day or 14-day duration" do
    registration = Registration.new(
      package: Package.new(name: "ShamanaM"),
      start_date: Date.current,
      lifestyle: "Active",
      substances: "None",
      health_conditions: "None",
      medication: "None",
      shamanam_duration: "10"
    )

    assert_not registration.valid?
    assert_includes registration.errors[:shamanam_duration], "must be 7 or 14 days"
  end
end
