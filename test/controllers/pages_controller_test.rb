require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "GET /privacy returns 200" do
    get privacy_path
    assert_response :success
  end

  test "privacy page has correct title" do
    get privacy_path
    assert_select "title", /プライバシーポリシー/
  end

  test "privacy page mentions Google Analytics" do
    get privacy_path
    assert_select "body", /Google アナリティクス/
  end
end
