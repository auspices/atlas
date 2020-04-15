# frozen_string_literal: true

module Mutations
  class Login < GraphQL::Schema::RelayClassicMutation
    argument :username, String, required: true
    argument :password, String, required: true

    field :jwt, String, null: false
    field :user, Types::UserType, null: false

    def resolve(username:, password:)
      user = User.find_by_username(username)

      return Errors::UnauthorizedError.new('Login failed. Invalid username or password.') if user.nil?

      if user.valid_password?(password)
        token = JsonWebToken.encode(id: user.id, env: ENV['RAILS_ENV'])
        return { jwt: token, user: user }
      end

      Errors::UnauthorizedError.new('Login failed. Invalid username or password.')
    end
  end
end
