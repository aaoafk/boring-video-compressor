require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test "should get how_to_use" do
    get pages_how_to_use_url
    assert_response :success
  end

  test "should get built_by" do
    get pages_built_by_url
    assert_response :success
  end
end
