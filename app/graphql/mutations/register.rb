# frozen_string_literal: true

module Mutations
  class Register < GraphQL::Schema::RelayClassicMutation
    argument :username, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :email, String, required: true

    field :jwt, String, null: false
    field :user, Types::UserType, null: false

    def resolve(username:, password:, password_confirmation:, email:)
      user = User.create!(
        username: username,
        password: password,
        password_confirmation: password_confirmation,
        email: email
      )

      token = JsonWebToken.encode(id: user.id, env: ENV['RAILS_ENV'])

      return { jwt: token, user: user }
    end
  end
end
