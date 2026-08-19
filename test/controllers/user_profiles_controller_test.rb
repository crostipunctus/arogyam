require "test_helper"

class UserProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "profile-registration@example.com",
      password: "password123",
      first_name: "Profile",
      last_name: "Participant",
      confirmed_at: Time.current
    )
    @package = Package.create!(
      name: "Profile Handoff Programme",
      cost: "100",
      duration: 7,
      short_description: "A programme used to verify the profile handoff"
    )
    sign_in @user
  end

  test "profile completion continues to the selected programme registration" do
    get new_user_profile_path(@user, package_id: @package.id)

    assert_response :success
    assert_select "input[type='hidden'][name='package_id'][value='#{@package.id}']"

    assert_difference("UserProfile.count", 1) do
      post user_profile_path(@user), params: {
        package_id: @package.id,
        user_profile: valid_profile_params
      }
    end

    assert_redirected_to new_registration_path(package_id: @package.id)
    assert_equal "Profile created successfully! Continue below to complete your registration.", flash[:notice]
  end

  private

  def valid_profile_params
    {
      gender: "Female",
      date_of_birth: Date.new(1990, 1, 1),
      address: "123 Wellness Road",
      city: "Chowdepalli",
      zip: "517257",
      country: "IN",
      phone_number: "9000000000",
      nationality: "IN",
      occupation: "Teacher"
    }
  end
end
