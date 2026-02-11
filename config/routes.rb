Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "reading_logs#index"

  resources :books
  resources :reading_logs

  get "up" => "rails/health#show", as: :rails_health_check
end
