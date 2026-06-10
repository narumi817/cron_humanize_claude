require "test_helper"

class CronBuilderServiceTest < ActiveSupport::TestCase
  test "毎分" do
    assert_equal "* * * * *", build("every_minute")
  end

  test "N分ごと" do
    assert_equal "*/15 * * * *", build("every_n_minutes", interval_minutes: 15)
  end

  test "毎時" do
    assert_equal "30 * * * *", build("every_hour", minute: 30)
  end

  test "N時間ごと" do
    assert_equal "0 */6 * * *", build("every_n_hours", interval_hours: 6, minute: 0)
  end

  test "毎日" do
    assert_equal "0 9 * * *", build("every_day", hour: 9, minute: 0)
  end

  test "毎週" do
    assert_equal "0 9 * * 1,5", build("every_week", weekdays: [ 1, 5 ], hour: 9, minute: 0)
  end

  test "毎週: 曜日未選択はnil" do
    assert_nil build("every_week", weekdays: [], hour: 9, minute: 0)
  end

  test "毎月" do
    assert_equal "0 9 1,15 * *", build("every_month", days: "1,15", hour: 9, minute: 0)
  end

  test "毎月: 日未入力はnil" do
    assert_nil build("every_month", days: "", hour: 9, minute: 0)
  end

  test "毎年" do
    assert_equal "0 9 1 4,10 *", build("every_year", months: "4,10", day: 1, hour: 9, minute: 0)
  end

  test "毎年: 月未入力はnil" do
    assert_nil build("every_year", months: "", day: 1, hour: 9, minute: 0)
  end

  test "frequency未指定はnil" do
    assert_nil CronBuilderService.new({}).call
  end

  private

  def build(frequency, **opts)
    CronBuilderService.new({ frequency: frequency }.merge(opts)).call
  end
end
