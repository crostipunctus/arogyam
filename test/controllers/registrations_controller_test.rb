require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create(email: 'test@example.com', password: 'password')
    @user.confirm
    @batch = Batch.create!(start_date: "24-04-2023", end_date: "25-04-2023", duration: "10", name: "nice batch") # Add required attributes for the Batch model
    @package = Package.create!(name: "nice package", cost: "100", duration: 10, short_description: "nice description", dates: "2nd to 4th") # Add required attributes for the Package model
  end

  test "should create registration" do
    sign_in @user
  
    assert_difference('Registration.count', 1, "Registration not created") do
      post registrations_path, params: { registration: { batch_id: @batch.id, package_id: @package.id, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1" } }
    end
  
  
    assert_redirected_to batches_path
    assert_equal 'Registered successfully', flash[:notice]
  end


  test "should not create registration without agreement or terms" do
    sign_in @user

    assert_no_difference('Registration.count') do
      post registrations_path, params: { registration: { batch_id: @batch.id, package_id: @package.id, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "0", terms: "0" } }
    end

    assert_response :unprocessable_entity
  end

  test "should cancel registration and update status" do
    sign_in @user
  
    # Create a new registration for the test
    registration = Registration.create(user: @user, batch: @batch, package: @package, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1")
  
    assert registration.persisted?, "Registration was not created"
    assert_no_difference('Registration.count', "Registration was deleted instead of being cancelled") do
      delete registration_path(registration)
    end
  
    registration.reload
    assert_equal 'Cancelled', registration.status, "Registration status was not updated to 'Cancelled'"
    assert registration.cancelled, "Registration cancelled attribute was not set to true"
    refute_includes @batch.registrations, registration, "Cancelled registration is still in the batch's registrations"
  
    assert_redirected_to :root_path
    assert_equal 'Registration cancelled successfully', flash[:notice]
  end
  

  def teardown
    @user.destroy
    @batch.destroy
    @package.destroy
  end
end
