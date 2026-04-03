Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root 'homes#show'

  resources :readings, only: %i[show new create edit update destroy]

  resources :books, only: %i[index create]

  get 'up' => 'rails/health#show', as: :rails_health_check
end
