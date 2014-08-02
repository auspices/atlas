Rails.application.routes.draw do
  resources :images, except: :edit
  get 'login' => 'auth#login'
  root to: 'images#index'
end
