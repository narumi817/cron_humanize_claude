class CronHumanizeService
  DAYS_JA = %w[日 月 火 水 木 金 土].freeze

  Result = Data.define(:description, :next_times, :error)

  def initialize(expression)
    @expression = expression.to_s.strip
  end

  def call
    cron = Fugit.parse_cron(@expression)
    return Result.new(description: nil, next_times: [], error: "無効なcron式です") unless cron

    Result.new(
      description: humanize,
      next_times: next_times(cron),
      error: nil
    )
  rescue StandardError
    Result.new(description: nil, next_times: [], error: "無効なcron式です")
  end

  private

  def humanize
    minute, hour, day, month, weekday = parse_fields

    if every_minute?(minute)
      return "毎分"
    elsif interval_minute?(minute)
      return "#{minute_interval(minute)}分ごと"
    end

    time_str = build_time_str(minute, hour)
    date_str = build_date_str(day, month, weekday)

    "#{date_str} #{time_str}".strip
  end

  def parse_fields
    @expression.split
  end

  def every_minute?(minute)
    minute == "*"
  end

  def interval_minute?(minute)
    minute.start_with?("*/")
  end

  def minute_interval(minute)
    minute.sub("*/", "")
  end

  def build_time_str(minute, hour)
    h = hour == "*" ? nil : hour.to_i
    m = minute == "*" ? 0 : minute.to_i

    if h.nil?
      "毎時#{m}分"
    else
      format("%d:%02d", h, m)
    end
  end

  def build_date_str(day, month, weekday)
    if month != "*"
      month_str = "#{month}月"
      day_str = day == "*" ? "" : "#{day}日"
      "毎年#{month_str}#{day_str}"
    elsif weekday != "*"
      "毎週#{humanize_weekday(weekday)}"
    elsif day != "*"
      "毎月#{day}日"
    else
      "毎日"
    end
  end

  # "1,3-5" のようなカンマとレンジの混合パターンは非対応
  def humanize_weekday(weekday)
    return weekday.split(",").map { |d| DAYS_JA[d.to_i] }.join("・") unless weekday.include?("-")

    range = weekday.split("-")
    "#{DAYS_JA[range.first.to_i]}〜#{DAYS_JA[range.last.to_i]}"
  end

  def next_times(cron)
    times = []
    t = Time.now
    5.times do
      t = cron.next_time(t)
      times << t.to_t
      t += 1.second
    end
    times
  end
end
