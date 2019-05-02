# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    def current_user
      user = context[:current_user]

      raise(Errors::UnauthorizedError, 'Login to continue.') if user.nil? || !user.persisted?

      user
    end

    def require_login!
      current_user
      nil
    end
  end
end
