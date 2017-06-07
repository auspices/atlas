# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root to: 'home#index'

  get 'logout', to: 'sessions#destroy', as: :logout
  get 'login', to: 'sessions#new', as: :login
  get 'register', to: 'users#new', as: :register

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      get '', to: 'root#index', as: :root
      resources :status, only: :index
      resources :users, only: :show do
        resources :images, only: %i[index show] do
          collection do
            get 'sample'
          end
        end
        resources :collections, only: %i[index show] do
          resources :images, only: :index, controller: 'collections/images' do
            collection do
              get 'sample'
            end
          end
        end
      end
    end
  end

  resources :sessions, only: %i[new create destroy]
  resources :users
  resources :users, path: '' do
    resources :images, except: %i[new edit update]
    resources :collections, except: %i[new edit update], path: '' do
      resources :images, only: %i[create], controller: 'collections/images'

      resources :images, only: [], path: '', controller: 'collections/images' do
        collection do
          get 'add/*source_url' => :add
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
