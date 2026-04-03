Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root 'homes#show'

  resource :profile,   only: %i[edit update]
  resources :readings, only: %i[show new create edit update destroy]
  resources :books,    only: %i[index create]

  namespace :public do
    resources :readings, only: %i[show], param: :share_token
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
