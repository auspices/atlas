Rails.application.routes.draw do
  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'login' => 'sessions#new', as: 'login'
  get 'register' => 'users#new', as: 'register'

  resources :users do
    resources :images, except: [:edit, :update]
  end

  resources :sessions

  root to: 'home#index'
end
