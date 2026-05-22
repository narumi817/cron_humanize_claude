Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "cron_expressions#index"
  get "privacy" => "pages#privacy"

  scope "/en", locale: "en" do
    root "cron_expressions#index", as: :en_root
    get "privacy" => "pages#privacy", as: :en_privacy
  end
end
