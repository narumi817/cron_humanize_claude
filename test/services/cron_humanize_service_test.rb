require "test_helper"

class CronHumanizeServiceTest < ActiveSupport::TestCase
  test "毎日特定時刻" do
    result = CronHumanizeService.new("0 9 * * *").call
    assert_nil result.error
    assert_equal "毎日 9:00", result.description
    assert_equal 5, result.next_times.length
  end

  test "毎週月曜から金曜" do
    result = CronHumanizeService.new("0 9 * * 1-5").call
    assert_nil result.error
    assert_equal "毎週月〜金 9:00", result.description
  end

  test "5分ごと" do
    result = CronHumanizeService.new("*/5 * * * *").call
    assert_nil result.error
    assert_equal "5分ごと", result.description
  end

  test "毎分" do
    result = CronHumanizeService.new("* * * * *").call
    assert_nil result.error
    assert_equal "毎分", result.description
  end

  test "毎月1日" do
    result = CronHumanizeService.new("0 0 1 * *").call
    assert_nil result.error
    assert_equal "毎月1日 0:00", result.description
  end

  test "毎年1月1日" do
    result = CronHumanizeService.new("0 0 1 1 *").call
    assert_nil result.error
    assert_equal "毎年1月1日 0:00", result.description
  end

  test "無効なcron式" do
    result = CronHumanizeService.new("invalid").call
    assert_equal "無効なcron式です", result.error
    assert_nil result.description
  end

  test "空文字列" do
    result = CronHumanizeService.new("").call
    assert_equal "無効なcron式です", result.error
  end

  test "マルチバイト文字" do
    result = CronHumanizeService.new("あ").call
    assert_equal "無効なcron式です", result.error
    assert_nil result.description
  end

  test "毎週水曜と金曜" do
    result = CronHumanizeService.new("0 12 * * 3,5").call
    assert_nil result.error
    assert_equal "毎週水・金 12:00", result.description
  end

  test "カンマとレンジが混在する曜日指定" do
    result = CronHumanizeService.new("0 5 * * 1,3-5").call
    assert_nil result.error
    assert_equal "毎週月・水〜金 5:00", result.description
  end

  test "毎月複数日（カンマ）" do
    result = CronHumanizeService.new("0 9 1,15 * *").call
    assert_nil result.error
    assert_equal "毎月1・15日 9:00", result.description
  end

  test "毎月日付レンジ" do
    result = CronHumanizeService.new("0 9 1-5 * *").call
    assert_nil result.error
    assert_equal "毎月1〜5日 9:00", result.description
  end

  test "毎年複数月（カンマ）" do
    result = CronHumanizeService.new("0 9 1 1,6 *").call
    assert_nil result.error
    assert_equal "毎年1・6月1日 9:00", result.description
  end

  test "毎年月レンジ" do
    result = CronHumanizeService.new("0 9 1 1-3 *").call
    assert_nil result.error
    assert_equal "毎年1〜3月1日 9:00", result.description
  end

  test "毎月カンマとレンジが混在する日指定" do
    result = CronHumanizeService.new("0 9 1,22-23 * *").call
    assert_nil result.error
    assert_equal "毎月1・22〜23日 9:00", result.description
  end

  test "毎年カンマとレンジが混在する月指定" do
    result = CronHumanizeService.new("0 9 1 1,3-5 *").call
    assert_nil result.error
    assert_equal "毎年1・3〜5月1日 9:00", result.description
  end

  test "分カンマ指定" do
    result = CronHumanizeService.new("0,30 9 * * *").call
    assert_nil result.error
    assert_equal "毎日 9時0・30分", result.description
  end

  test "分レンジ指定" do
    result = CronHumanizeService.new("0-30 9 * * *").call
    assert_nil result.error
    assert_equal "毎日 9時0〜30分", result.description
  end

  test "時カンマ指定" do
    result = CronHumanizeService.new("0 9,17 * * *").call
    assert_nil result.error
    assert_equal "毎日 9・17時0分", result.description
  end

  test "時レンジ指定" do
    result = CronHumanizeService.new("0 9-17 * * *").call
    assert_nil result.error
    assert_equal "毎日 9〜17時0分", result.description
  end

  test "時と分の両方をカンマ指定" do
    result = CronHumanizeService.new("0,30 9,17 * * *").call
    assert_nil result.error
    assert_equal "毎日 9・17時0・30分", result.description
  end

  test "毎時カンマ指定の分" do
    result = CronHumanizeService.new("0,30 * * * *").call
    assert_nil result.error
    assert_equal "毎日 毎時0・30分", result.description
  end

  test "分のカンマとレンジ混合指定" do
    result = CronHumanizeService.new("0,15-30 9 * * *").call
    assert_nil result.error
    assert_equal "毎日 9時0・15〜30分", result.description
  end

  test "時のカンマとレンジ混合指定" do
    result = CronHumanizeService.new("0 9,12-17 * * *").call
    assert_nil result.error
    assert_equal "毎日 9・12〜17時0分", result.description
  end

  test "時フィールドのステップ値（分はワイルドカード）" do
    result = CronHumanizeService.new("* */2 * * *").call
    assert_nil result.error
    assert_equal "毎日 2時間ごと", result.description
  end

  test "時フィールドのステップ値（特定の分）" do
    result = CronHumanizeService.new("0 */2 * * *").call
    assert_nil result.error
    assert_equal "毎日 2時間ごとの0分", result.description
  end

  test "日フィールドのステップ値" do
    result = CronHumanizeService.new("0 0 */5 * *").call
    assert_nil result.error
    assert_equal "5日ごと 0:00", result.description
  end

  test "月フィールドのステップ値" do
    result = CronHumanizeService.new("0 0 1 */3 *").call
    assert_nil result.error
    assert_equal "3ヶ月ごと1日 0:00", result.description
  end
end
