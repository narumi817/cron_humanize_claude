class CronBuilderService
  def initialize(params)
    @frequency        = params[:frequency].to_s
    @interval_minutes = [ params[:interval_minutes].to_i, 1 ].max
    @interval_hours   = [ params[:interval_hours].to_i, 1 ].max
    @hour             = params[:hour].to_i.clamp(0, 23)
    @minute           = params[:minute].to_i.clamp(0, 59)
    @weekdays         = Array(params[:weekdays]).map(&:to_i).sort
    @days             = params[:days].to_s.strip
    @months           = params[:months].to_s.strip
    @day              = params[:day].to_i.clamp(1, 31)
  end

  def call
    return nil if @frequency.blank?

    build_expression
  end

  private

  def build_expression
    case @frequency
    when "every_minute"    then "* * * * *"
    when "every_n_minutes" then "*/#{@interval_minutes} * * * *"
    when "every_hour"      then "#{@minute} * * * *"
    when "every_n_hours"   then "#{@minute} */#{@interval_hours} * * *"
    when "every_day"       then "#{@minute} #{@hour} * * *"
    when "every_week"      then build_weekly
    when "every_month"     then build_monthly
    when "every_year"      then build_yearly
    end
  end

  def build_weekly
    return nil if @weekdays.empty?

    "#{@minute} #{@hour} * * #{@weekdays.join(',')}"
  end

  def build_monthly
    return nil if @days.blank?

    "#{@minute} #{@hour} #{@days} * *"
  end

  def build_yearly
    return nil if @months.blank?

    "#{@minute} #{@hour} #{@day} #{@months} *"
  end
end
