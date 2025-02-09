# frozen_string_literal: true

module Mutations
  class Register < GraphQL::Schema::RelayClassicMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :secret, String, required: true
    argument :username, String, required: true

    field :jwt, String, null: false
    field :user, Types::UserType, null: false

    def resolve(secret:, username:, password:, password_confirmation:, email:)
      return Errors::UnauthorizedError.new('Secret is invalid.') if secret != ENV['REGISTRATION_SECRET']

      ActiveRecord::Base.transaction do
        user = User.create!(
          username:,
          password:,
          password_confirmation:,
          email:
        )

        user.create_customer!

        token = JsonWebToken.encode(id: user.id, env: ENV.fetch('RAILS_ENV', nil))

        { jwt: token, user: }
      end
    end
  end
end
