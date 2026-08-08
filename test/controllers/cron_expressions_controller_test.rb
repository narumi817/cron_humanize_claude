require "test_helper"

class CronExpressionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @original_ga_id = ENV["GOOGLE_ANALYTICS_ID"]
    ENV["GOOGLE_ANALYTICS_ID"] = "G-TEST"
  end

  teardown do
    ENV["GOOGLE_ANALYTICS_ID"] = @original_ga_id
  end

  test "GET / returns 200" do
    get root_path
    assert_response :success
  end

  test "cron式を変換して結果を表示" do
    get root_path, params: { cron_expression: "0 9 * * *" }
    assert_response :success
    assert_select ".human-text"
  end

  test "変換成功時にconvertイベントを送信" do
    get root_path, params: { cron_expression: "0 9 * * *" }
    assert_match "gtag('event', 'convert');", response.body
  end

  test "変換失敗時にconvert_errorイベントを送信" do
    get root_path, params: { cron_expression: "invalid" }
    assert_response :success
    assert_select ".result.error"
    assert_match "gtag('event', 'convert_error');", response.body
  end

  test "初回表示時はイベントを送信しない" do
    get root_path
    assert_no_match "gtag('event',", response.body
  end

  test "GOOGLE_ANALYTICS_ID未設定時はイベントを送信しない" do
    ENV["GOOGLE_ANALYTICS_ID"] = nil
    get root_path, params: { cron_expression: "0 9 * * *" }
    assert_response :success
    assert_no_match "gtag(", response.body
  end
end
