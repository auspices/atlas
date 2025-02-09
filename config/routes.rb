# frozen_string_literal: true

Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  post '/graph', to: 'graphql#execute'
  post '/graph/:key', to: 'object_graphql#execute'

  root to: 'home#index'

  match '/*path', to: 'errors#not_found', via: :all
end
