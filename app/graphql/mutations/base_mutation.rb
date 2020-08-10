# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    def current_user
      context[:current_user].tap do |user|
        raise(Errors::UnauthorizedError, 'login to continue') if user.nil? || !user.persisted?
      end
    end
  end
end
