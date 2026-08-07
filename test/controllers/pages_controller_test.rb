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

  test "英語ルートのリクエスト後もロケールが漏れない" do
    get en_privacy_path
    assert_select "title", /Privacy Policy/
    assert_equal I18n.default_locale, I18n.locale

    get privacy_path
    assert_select "title", /プライバシーポリシー/
  end
end
