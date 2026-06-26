Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "robots.txt" => "pages#robots", as: :robots
  get "family-stock/privacy" => "pages#family_stock_privacy"

  root "cron_expressions#index"
  get "privacy" => "pages#privacy"
  get "terms" => "pages#terms"
  get "build" => "cron_builder#index"

  scope "/en", locale: "en" do
    root "cron_expressions#index", as: :en_root
    get "privacy" => "pages#privacy", as: :en_privacy
    get "terms" => "pages#terms", as: :en_terms
    get "build" => "cron_builder#index", as: :en_build
  end
end
