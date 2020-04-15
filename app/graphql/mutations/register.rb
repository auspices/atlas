# frozen_string_literal: true

module Mutations
  class Register < GraphQL::Schema::RelayClassicMutation
    argument :secret, String, required: true
    argument :username, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :email, String, required: true

    field :jwt, String, null: false
    field :user, Types::UserType, null: false

    def resolve(secret:, username:, password:, password_confirmation:, email:)
      return Errors::UnauthorizedError.new('Secret is invalid.') if secret != ENV['REGISTRATION_SECRET']

      user = User.create!(
        username: username,
        password: password,
        password_confirmation: password_confirmation,
        email: email
      )

      token = JsonWebToken.encode(id: user.id, env: ENV['RAILS_ENV'])

      { jwt: token, user: user }
    end
  end
end
