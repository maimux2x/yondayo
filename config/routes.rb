Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root 'books#index'

  resources :books

  get 'up' => 'rails/health#show', as: :rails_health_check
end
