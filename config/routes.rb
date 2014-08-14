Rails.application.routes.draw do
  resources :sessions
  resources :users do
    resources :collections, except: [:new, :edit, :update] do
      resources :images, only: [:index, :create], controller: 'collections/images'
    end
    resources :images, except: [:new, :edit, :update]
  end

  get 'logout', to: 'sessions#destroy', as: :logout
  get 'login', to: 'sessions#new', as: :login
  get 'register', to: 'users#new', as: :register
  get ':user_id', to: 'collections#index', as: :vanity_user_collections
  get ':user_id/:collection_id', to: 'collections/images#index', as: :vanity_user_collections_images

  root to: 'home#index'
end
