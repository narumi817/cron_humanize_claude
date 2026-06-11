class CronBuilderController < ApplicationController
  def index
    @frequency = params[:frequency] || "every_day"
    return unless params[:frequency].present?

    @cron_expression = CronBuilderService.new(params).call
    @next_times = CronHumanizeService.new(@cron_expression).call.next_times if @cron_expression
  end
end
