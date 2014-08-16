Rails.application.routes.draw do
  root to: 'home#index'

  get 'logout', to: 'sessions#destroy', as: :logout
  get 'login', to: 'sessions#new', as: :login
  get 'register', to: 'users#new', as: :register

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :users, path: '' do
    resources :images, except: [:new, :edit, :update]
    resources :collections, except: [:new, :edit, :update], path: '' do
      resources :images, only: [:index, :create], controller: 'collections/images'
    end
  end
end
