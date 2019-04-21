# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    def current_user
      user = context[:current_user]

      raise(Errors::UnauthorizedError, 'Login to continue.') if user.nil? || !user.persisted?

      user
    end
  end
end
