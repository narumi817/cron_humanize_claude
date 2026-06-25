class PagesController < ApplicationController
  def robots
    expires_in 24.hours, public: true
    render "robots", formats: [ :text ], layout: false
  end

  def privacy
  end

  def terms
  end
end
