class CronBuilderController < ApplicationController
  def index
    @frequency = params[:frequency] || "every_day"
    return unless params[:frequency].present?

    @cron_expression = CronBuilderService.new(params).call
    @result = CronHumanizeService.new(@cron_expression).call if @cron_expression
  end
end
