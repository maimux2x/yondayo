Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root 'readings#index'

  resources :readings, only: %i[index new create show edit update destroy]

  resources :books, only: %i[create update] do
    collection do
      get 'search'
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
