require "test_helper"

class AdminWriteAuthorizationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @announcement = Announcement.create!(content: "Original announcement")
    @package = Package.create!(name: "Original programme")
  end

  test "guests cannot update announcements" do
    patch update_announcement_path(@announcement), params: { announcement: { content: "Tampered" } }

    assert_redirected_to new_user_session_path
    assert_equal "Original announcement", @announcement.reload.content
  end

  test "guests cannot update programmes" do
    patch programme_path(@package), params: { package: { name: "Tampered" } }

    assert_redirected_to new_user_session_path
    assert_equal "Original programme", @package.reload.name
  end

  test "guests cannot create testimonials" do
    assert_no_difference("Testimonial.count") do
      post testimonials_path, params: { testimonial: { title: "Untrusted", youtube_id: "video" } }
    end

    assert_redirected_to new_user_session_path
  end

  test "admins retain access to protected content actions" do
    sign_in create_admin

    patch update_announcement_path(@announcement), params: { announcement: { content: "Updated" } }
    assert_redirected_to announcements_path
    assert_equal "Updated", @announcement.reload.content

    patch programme_path(@package), params: { package: { name: "Updated programme" } }
    assert_redirected_to programme_path(@package.reload)

    assert_difference("Testimonial.count", 1) do
      post testimonials_path, params: { testimonial: { title: "Approved", youtube_id: "video" } }
    end
    assert_redirected_to testimonials_path
  end

  test "state-changing create actions are not routable by GET" do
    assert_raises(ActionController::RoutingError) do
      Rails.application.routes.recognize_path("/contacts/create", method: :get)
    end

    assert_raises(ActionController::RoutingError) do
      Rails.application.routes.recognize_path("/newsletter_subscriptions/create", method: :get)
    end
  end

  private

  def create_admin
    User.create!(
      email: "admin@example.com",
      password: "password123",
      privacy_policy: "1",
      admin: true,
      confirmed_at: Time.current
    )
  end
end
