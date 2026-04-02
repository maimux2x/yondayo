Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root 'readings#index'

  resources :readings, only: %i[index new create show edit update destroy]

  resources :books, only: %i[index create]

  get 'up' => 'rails/health#show', as: :rails_health_check
end
