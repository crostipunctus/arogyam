require 'test_helper'

class SignupAndRegistrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @package = Package.create!(name: "Panchakarma", cost: "15000", duration: 14, short_description: "A 14-day detox programme", dates: "Year round")
  end

  def teardown
    Registration.destroy_all
    User.destroy_all
    @package.destroy
  end

  # === SIGN UP TESTS ===

  test "new user can sign up with valid details" do
    assert_difference('User.count', 1) do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          first_name: "Arjun",
          last_name: "Sharma",
          password: "password123",
          password_confirmation: "password123",
          privacy_policy: "1"
        },
        recaptcha_token: "test_token"
      }
    end

    user = User.last
    assert_equal "newuser@example.com", user.email
    assert_equal "Arjun", user.first_name
    assert_equal "Sharma", user.last_name
  end

  test "sign up fails without privacy policy acceptance" do
    assert_no_difference('User.count') do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          first_name: "Arjun",
          last_name: "Sharma",
          password: "password123",
          password_confirmation: "password123",
          privacy_policy: "0"
        },
        recaptcha_token: "test_token"
      }
    end
  end

  test "sign up fails with mismatched passwords" do
    assert_no_difference('User.count') do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          first_name: "Arjun",
          last_name: "Sharma",
          password: "password123",
          password_confirmation: "wrongpassword",
          privacy_policy: "1"
        },
        recaptcha_token: "test_token"
      }
    end
  end

  test "sign up fails with duplicate email" do
    User.create!(email: "taken@example.com", password: "password123", first_name: "Existing", last_name: "User", privacy_policy: "1")

    assert_no_difference('User.count') do
      post user_registration_path, params: {
        user: {
          email: "taken@example.com",
          first_name: "Another",
          last_name: "User",
          password: "password123",
          password_confirmation: "password123",
          privacy_policy: "1"
        },
        recaptcha_token: "test_token"
      }
    end
  end

  # === SIGN IN FEEDBACK TESTS (Turbo) ===
  # Regression: a failed Turbo sign-in used to return a 401 that Turbo discarded,
  # so the user was bounced back to the form with no message. The Turbo failure
  # app now redirects, persisting flash[:alert] so the reason is actually shown.

  test "unconfirmed user sees confirm-email alert on failed login" do
    User.create!(
      email: "unconfirmed@example.com",
      password: "password123",
      first_name: "Un",
      last_name: "Confirmed",
      privacy_policy: "1"
    )

    post user_session_path,
         params: { user: { email: "unconfirmed@example.com", password: "password123" } },
         headers: { "Accept" => "text/vnd.turbo-stream.html, text/html" }

    assert_redirected_to new_user_session_path
    assert_match(/confirm your email/i, flash[:alert].to_s)
  end

  test "wrong password shows invalid alert on failed login" do
    user = User.create!(
      email: "confirmed@example.com",
      password: "password123",
      first_name: "Con",
      last_name: "Firmed",
      privacy_policy: "1"
    )
    user.confirm

    post user_session_path,
         params: { user: { email: "confirmed@example.com", password: "wrongpassword" } },
         headers: { "Accept" => "text/vnd.turbo-stream.html, text/html" }

    assert_redirected_to new_user_session_path
    assert_match(/invalid/i, flash[:alert].to_s)
  end

  test "password reset for unknown email gives neutral paranoid message (no enumeration)" do
    post user_password_path,
         params: { user: { email: "nobody@example.com" } }

    assert_redirected_to new_user_session_path
    assert_match(/if your email address exists/i, flash[:notice].to_s)
    assert_no_match(/not found/i, flash[:notice].to_s + flash[:alert].to_s)
  end

  # === REGISTRATION FLOW TESTS ===

  test "authenticated user can submit registration form" do
    user = create_and_sign_in_user

    post registrations_path, params: {
      registration: valid_registration_params
    }

    assert_redirected_to review_registrations_path
  end

  test "registration fails without required health fields" do
    user = create_and_sign_in_user

    post registrations_path, params: {
      registration: {
        package_id: @package.id,
        start_date: 2.weeks.from_now.to_date,
        lifestyle: "",
        substances: "",
        health_conditions: "",
        medication: "",
        agreement: "1",
        terms: "1"
      }
    }

    assert_response :unprocessable_entity
  end

  test "registration fails without agreement and terms" do
    user = create_and_sign_in_user

    post registrations_path, params: {
      registration: valid_registration_params.merge(agreement: "0", terms: "0")
    }

    assert_response :unprocessable_entity
  end

  test "review page shows registration details" do
    user = create_and_sign_in_user

    post registrations_path, params: {
      registration: valid_registration_params
    }

    get review_registrations_path
    assert_response :success
    assert_select "#registration_review", text: "Registration Review"
  end

  test "review redirects if no registration in session" do
    user = create_and_sign_in_user

    get review_registrations_path
    assert_redirected_to new_registration_path
  end

  test "confirm creates the registration" do
    user = create_and_sign_in_user

    # Step 1: Submit form to store in session
    post registrations_path, params: {
      registration: valid_registration_params
    }

    # Step 2: Confirm
    assert_difference('Registration.count', 1) do
      post confirm_registrations_path
    end

    registration = Registration.last
    assert_equal user, registration.user
    assert_equal @package, registration.package
    assert_equal "Registered", registration.status
    assert_redirected_to root_path
    assert_equal "Registered successfully", flash[:notice]
  end

  test "user cannot register twice with an active registration" do
    user = create_and_sign_in_user

    # Complete first registration
    post registrations_path, params: { registration: valid_registration_params }
    post confirm_registrations_path

    assert_equal 1, Registration.count

    # Try to register again
    post registrations_path, params: { registration: valid_registration_params }

    assert_response :unprocessable_entity
  end

  test "user can register again after cancelling previous registration" do
    user = create_and_sign_in_user

    # Complete and cancel first registration
    post registrations_path, params: { registration: valid_registration_params }
    post confirm_registrations_path
    registration = Registration.last
    delete registration_path(registration)

    registration.reload
    assert registration.cancelled

    # Should be able to register again
    post registrations_path, params: { registration: valid_registration_params }
    assert_redirected_to review_registrations_path
  end

  test "unauthenticated user cannot access registration form" do
    get new_registration_path
    assert_redirected_to new_user_session_path
  end

  test "cancel registration sets cancelled status" do
    user = create_and_sign_in_user

    post registrations_path, params: { registration: valid_registration_params }
    post confirm_registrations_path

    registration = Registration.last
    delete registration_path(registration)

    registration.reload
    assert registration.cancelled
    assert_equal "Cancelled", registration.status
  end

  private

  def create_and_sign_in_user
    user = User.create!(
      email: "testuser@example.com",
      password: "password123",
      first_name: "Test",
      last_name: "User",
      privacy_policy: "1"
    )
    user.confirm
    sign_in user
    user
  end

  def valid_registration_params
    {
      package_id: @package.id,
      start_date: 2.weeks.from_now.to_date,
      lifestyle: "Active lifestyle with regular exercise",
      substances: "None",
      health_conditions: "No major conditions",
      medication: "None",
      agreement: "1",
      terms: "1"
    }
  end
end
