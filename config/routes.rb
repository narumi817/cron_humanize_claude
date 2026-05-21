Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "cron_expressions#index"

  get "privacy" => "pages#privacy"
end
