require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create(email: 'test@example.com', password: 'password')
    @user.confirm
    @package = Package.create!(name: "nice package", cost: "100", duration: 10, short_description: "nice description", dates: "2nd to 4th")
  end

  test "should stage a valid registration for review" do
    sign_in @user

    assert_no_difference('Registration.count') do
      post registrations_path, params: { registration: { package_id: @package.id, start_date: 2.weeks.from_now.to_date, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1" } }
    end

    assert_redirected_to review_registrations_path
  end


  test "should not create registration without agreement or terms" do
    sign_in @user

    assert_no_difference('Registration.count') do
      post registrations_path, params: { registration: { package_id: @package.id, start_date: 2.weeks.from_now.to_date, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "0", terms: "0" } }
    end

    assert_response :unprocessable_entity
  end

  test "should cancel registration and update status" do
    sign_in @user

    registration = Registration.create(user: @user, package: @package, start_date: 2.weeks.from_now.to_date, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1")

    assert registration.persisted?, "Registration was not created"
    assert_no_difference('Registration.count', "Registration was deleted instead of being cancelled") do
      delete registration_path(registration)
    end

    registration.reload
    assert_equal 'Cancelled', registration.status, "Registration status was not updated to 'Cancelled'"
    assert registration.cancelled, "Registration cancelled attribute was not set to true"

    assert_redirected_to root_path
    assert_equal 'Registration cancelled successfully', flash[:notice]
  end


  def teardown
    @user.destroy
    @package.destroy
  end
end
