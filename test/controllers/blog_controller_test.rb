require "test_helper"

class BlogControllerTest < ActionDispatch::IntegrationTest
  test "journal is hidden from public visitors" do
    get blogs_path

    assert_redirected_to root_path
  end

  test "navigation no longer links to the journal" do
    get root_path

    assert_response :success
    assert_select "a[href=?]", blogs_path, count: 0
  end
end
