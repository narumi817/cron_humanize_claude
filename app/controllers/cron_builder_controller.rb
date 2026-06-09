class CronBuilderController < ApplicationController
  def index
    @frequency = params[:frequency] || "every_day"
  end
end
