class CronExpressionsController < ApplicationController
  def index
    expression = params[:cron_expression]
    return unless expression.present?

    @cron_expression = expression
    @result = CronHumanizeService.new(expression).call
  end
end
