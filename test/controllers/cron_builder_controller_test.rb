require "test_helper"

class CronBuilderControllerTest < ActionDispatch::IntegrationTest
  test "GET /build returns 200" do
    get build_path
    assert_response :success
  end

  test "frequency未指定時はcron式を生成しない" do
    get build_path
    assert_select ".result", count: 0
  end

  test "毎日でcron式と説明を表示" do
    get build_path, params: { frequency: "every_day", hour: 9, minute: 0 }
    assert_response :success
    assert_select "h2", "0 9 * * *"
    assert_select ".human-text", count: 0
    assert_select ".next-times li", count: 5
  end

  test "毎週でcron式を表示" do
    get build_path, params: { frequency: "every_week", "weekdays[]": [ 1, 5 ], hour: 9, minute: 0 }
    assert_response :success
    assert_select "h2", "0 9 * * 1,5"
  end

  test "毎週で曜日未選択の場合は結果を表示しない" do
    get build_path, params: { frequency: "every_week", hour: 9, minute: 0 }
    assert_select ".result", count: 0
  end
end
