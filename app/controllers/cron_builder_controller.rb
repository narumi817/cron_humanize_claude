class CronBuilderController < ApplicationController
  MAJOR_TIMEZONES = [
    "Tokyo", "Seoul", "Hong Kong", "Beijing", "Singapore", "Bangkok",
    "Mumbai", "Dubai", "Moscow", "Helsinki", "Berlin", "London", "UTC",
    "Atlantic Time (Canada)", "Eastern Time (US & Canada)",
    "Central Time (US & Canada)", "Mountain Time (US & Canada)",
    "Pacific Time (US & Canada)", "Alaska", "Hawaii",
    "Auckland", "Sydney"
  ].freeze

  def index
    @frequency = params[:frequency] || "every_day"
    return unless params[:frequency].present?

    @cron_expression = CronBuilderService.new(params).call
    @next_times = CronHumanizeService.new(@cron_expression, timezone: params[:timezone]).call.next_times if @cron_expression
  end
end
