require "test_helper"

class TestimonialsControllerTest < ActionDispatch::IntegrationTest
  test "testimonials are linked directly from the primary navigation" do
    get testimonials_path

    assert_response :success
    assert_select ".site-nav__links > .nav-item > a.nav-link[href='#{testimonials_path}']", text: "Testimonials", count: 1
    assert_select "#visitMenu + .dropdown-menu a[href='#{testimonials_path}']", count: 0
    assert_select ".site-footer__nav a[href='#{testimonials_path}']", text: "Testimonials", count: 1
    assert_select ".page-hero .eyebrow", text: "Testimonials"
  end
end
