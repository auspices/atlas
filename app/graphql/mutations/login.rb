# frozen_string_literal: true

module Mutations
  class Login < GraphQL::Schema::RelayClassicMutation
    argument :username, String, required: true
    argument :password, String, required: true

    field :jwt, String, null: false

    def resolve(username:, password:)
      user = User.find_by_username(username)

      return Errors::UnauthorizedError.new('Login failed. Invalid email or password.') if user.nil?

      if user.valid_password?(password)
        token = JsonWebToken.encode(id: user.id)
        return { jwt: token }
      end

      Errors::UnauthorizedError.new('Login failed. Invalid email or password.')
    end
  end
end
