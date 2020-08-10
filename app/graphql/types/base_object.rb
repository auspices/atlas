# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    def current_user(subscribed_to: [])
      context[:current_user].tap do |user|
        raise(Errors::UnauthorizedError, 'login to continue') if user.nil? || !user.persisted?
        if subscribed_to.present? && !user.subscribed_to?(*subscribed_to)
          raise(Errors::UnauthorizedError, 'subscribe to continue')
        end
      end
    end

    def require_login!
      current_user
      nil
    end
  end
end
