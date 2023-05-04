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

  test "should not create duplicate registration" do
    sign_in @user
    registration = Registration.create(user: @user, batch: @batch, package: @package, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None")

    assert_no_difference('Registration.count') do
      post registrations_path, params: { registration: { batch_id: @batch.id, package_id: @package.id, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "1", terms: "1" } }
    end

    assert_redirected_to batches_path
    assert_equal 'You have already registered for this batch', flash[:alert]
  end

  test "should not create registration without agreement or terms" do
    sign_in @user

    assert_no_difference('Registration.count') do
      post registrations_path, params: { registration: { batch_id: @batch.id, package_id: @package.id, lifestyle: "Active", substances: "None", health_conditions: "None", medication: "None", agreement: "0", terms: "0" } }
    end

    assert_response :unprocessable_entity
  end

  def teardown
    @user.destroy
    @batch.destroy
    @package.destroy
  end
end
