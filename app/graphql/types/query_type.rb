# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: false,
      description: 'The logged in current user  '

    field :customer, Types::CustomerType, null: false,
      description: 'Bypass subscription check to access the current customer'

    def me
      current_user(subscribed_to: [:gaea])
    end

    delegate :customer, to: :current_user
  end
end
