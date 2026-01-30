Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "book_logs#index"

  resources :book_logs

  get "up" => "rails/health#show", as: :rails_health_check
end
