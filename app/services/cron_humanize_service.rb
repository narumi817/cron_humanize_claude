class CronHumanizeService
  Result = Data.define(:description, :next_times, :error)

  def initialize(expression, timezone: nil)
    @expression = expression.to_s.strip
    @timezone = timezone.presence || Time.zone.name
  end

  def call
    cron = Fugit.parse_cron(@expression)
    return Result.new(description: nil, next_times: [], error: I18n.t("cron_humanize.invalid")) unless cron

    Result.new(
      description: humanize,
      next_times: next_times(cron),
      error: nil
    )
  rescue StandardError => e
    Rails.logger.error("CronHumanizeService error: #{e.message}")
    Result.new(description: nil, next_times: [], error: I18n.t("cron_humanize.invalid"))
  end

  private

  def humanize
    minute, hour, day, month, weekday = @expression.split

    all_wildcard = [ hour, day, month, weekday ].all? { |f| f == "*" }
    return I18n.t("cron_humanize.every_minute") if every_minute?(minute) && all_wildcard
    return I18n.t("cron_humanize.every_n_minutes", n: step_value(minute)) if step_field?(minute) && all_wildcard

    time_str = build_time_str(minute, hour)
    date_str = build_date_str(day, month, weekday)

    "#{date_str} #{time_str}".strip
  end

  def every_minute?(minute)
    minute == "*"
  end

  def step_field?(field)
    field.start_with?("*/")
  end

  def step_value(field)
    field.sub("*/", "")
  end

  def build_time_str(minute, hour)
    if step_field?(hour)
      if every_minute?(minute)
        I18n.t("cron_humanize.every_n_hours", n: step_value(hour))
      else
        I18n.t("cron_humanize.every_n_hours_at_minute", n: step_value(hour), m: humanize_numeric_field(minute))
      end
    elsif hour == "*"
      I18n.t("cron_humanize.every_hour_at_minute", m: humanize_numeric_field(minute))
    elsif single_value?(hour) && single_value?(minute)
      format("%d:%02d", hour.to_i, minute.to_i)
    else
      I18n.t("cron_humanize.at_time", hour: humanize_numeric_field(hour), minute: humanize_numeric_field(minute))
    end
  end

  def single_value?(field)
    field.match?(/\A\d+\z/)
  end

  def build_date_str(day, month, weekday)
    if step_field?(month)
      if day == "*"
        I18n.t("cron_humanize.every_n_months", n: step_value(month))
      else
        I18n.t("cron_humanize.every_n_months_on_day", n: step_value(month), day: humanize_numeric_field(day))
      end
    elsif month != "*"
      if day == "*"
        I18n.t("cron_humanize.every_year_on_month_only", month: humanize_numeric_field(month))
      else
        I18n.t("cron_humanize.every_year_on", month: humanize_numeric_field(month), day: humanize_numeric_field(day))
      end
    elsif weekday != "*"
      I18n.t("cron_humanize.every_week", days: humanize_weekday(weekday))
    elsif step_field?(day)
      I18n.t("cron_humanize.every_n_days", n: step_value(day))
    elsif day != "*"
      I18n.t("cron_humanize.every_month_on_day", day: humanize_numeric_field(day))
    else
      I18n.t("cron_humanize.every_day")
    end
  end

  def humanize_numeric_field(field)
    field.split(",").map { |token| humanize_numeric_token(token) }.join(I18n.t("cron_humanize.list_separator"))
  end

  def humanize_numeric_token(token)
    return token unless token.include?("-")

    parts = token.split("-")
    "#{parts.first}#{I18n.t('cron_humanize.range_separator')}#{parts.last}"
  end

  def humanize_weekday(weekday)
    weekday.split(",").map { |token| humanize_weekday_token(token) }.join(I18n.t("cron_humanize.list_separator"))
  end

  def humanize_weekday_token(token)
    days = I18n.t("date.abbr_day_names")
    return days[token.to_i] unless token.include?("-")

    range = token.split("-")
    "#{days[range.first.to_i]}#{I18n.t('cron_humanize.range_separator')}#{days[range.last.to_i]}"
  end

  def next_times(cron)
    times = []
    t = Time.current.in_time_zone(@timezone)
    5.times do
      t = cron.next_time(t)
      times << t.to_t.in_time_zone(@timezone)
      t += 1.second
    end
    times
  end
end
