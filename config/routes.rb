Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "cron_expressions#index"
  get "privacy" => "pages#privacy"
  get "build" => "cron_builder#index"

  scope "/en", locale: "en" do
    root "cron_expressions#index", as: :en_root
    get "privacy" => "pages#privacy", as: :en_privacy
    # get "build" => "cron_builder#index", as: :en_build  # Step 5 (i18n) 完了後に有効化
  end
end
