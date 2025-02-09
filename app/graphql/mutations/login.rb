# frozen_string_literal: true

module Mutations
  class Login < GraphQL::Schema::RelayClassicMutation
    argument :password, String, required: true
    argument :username, String, required: true

    field :jwt, String, null: false
    field :user, Types::UserType, null: false

    def resolve(username:, password:)
      user = User.find_by(username: username)

      return Errors::UnauthorizedError.new('Login failed. Invalid username or password.') if user.nil?

      if user.valid_password?(password)
        token = JsonWebToken.encode(id: user.id, env: ENV.fetch('RAILS_ENV', nil))
        return { jwt: token, user: }
      end

      Errors::UnauthorizedError.new('Login failed. Invalid username or password.')
    end
  end
end
