require "test_helper"

class AccommodationControllerTest < ActionDispatch::IntegrationTest
  test "does not create a database session for a new anonymous visitor" do
    assert_no_difference -> { ActiveRecord::SessionStore::Session.count } do
      get accommodation_path
    end

    assert_response :success
  end

  test "rejects a null byte in the raw request location before storing it" do
    get accommodation_path, env: { "SCRIPT_NAME" => "\0" }

    assert_response :bad_request
  end
end
