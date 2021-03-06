# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  post '/graphql', to: 'graphql#execute'

  post '/graph', to: 'graphql#execute'
  post '/graph/:key', to: 'object_graphql#execute'

  root to: 'home#index'

  match '/*path', to: 'errors#not_found', via: :all
end
