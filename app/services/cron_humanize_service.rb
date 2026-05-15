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
  rescue StandardError => e
    Rails.logger.error("CronHumanizeService error: #{e.message}")
    Result.new(description: nil, next_times: [], error: "無効なcron式です")
  end

  private

  def humanize
    minute, hour, day, month, weekday = @expression.split

    return "毎分" if every_minute?(minute)
    return "#{minute_interval(minute)}分ごと" if interval_minute?(minute)

    time_str = build_time_str(minute, hour)
    date_str = build_date_str(day, month, weekday)

    "#{date_str} #{time_str}".strip
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
    if hour == "*"
      "毎時#{humanize_numeric_field(minute)}分"
    elsif single_value?(hour) && single_value?(minute)
      format("%d:%02d", hour.to_i, minute.to_i)
    else
      "#{humanize_numeric_field(hour)}時#{humanize_numeric_field(minute)}分"
    end
  end

  def single_value?(field)
    field.match?(/\A\d+\z/)
  end

  def build_date_str(day, month, weekday)
    if month != "*"
      month_str = "#{humanize_numeric_field(month)}月"
      day_str = day == "*" ? "" : "#{humanize_numeric_field(day)}日"
      "毎年#{month_str}#{day_str}"
    elsif weekday != "*"
      "毎週#{humanize_weekday(weekday)}"
    elsif day != "*"
      "毎月#{humanize_numeric_field(day)}日"
    else
      "毎日"
    end
  end

  def humanize_numeric_field(field)
    field.split(",").map { |token| humanize_numeric_token(token) }.join("・")
  end

  def humanize_numeric_token(token)
    return token unless token.include?("-")

    parts = token.split("-")
    "#{parts.first}〜#{parts.last}"
  end

  def humanize_weekday(weekday)
    weekday.split(",").map { |token| humanize_weekday_token(token) }.join("・")
  end

  def humanize_weekday_token(token)
    return DAYS_JA[token.to_i] unless token.include?("-")

    range = token.split("-")
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
