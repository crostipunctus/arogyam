require "test_helper"

class CaseSheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get case_sheets_show_url
    assert_response :success
  end

  test "should get new" do
    get case_sheets_new_url
    assert_response :success
  end

  test "should get create" do
    get case_sheets_create_url
    assert_response :success
  end

  test "should get edit" do
    get case_sheets_edit_url
    assert_response :success
  end

  test "should get update" do
    get case_sheets_update_url
    assert_response :success
  end

  test "should get destroy" do
    get case_sheets_destroy_url
    assert_response :success
  end
end
