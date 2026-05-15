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
end
