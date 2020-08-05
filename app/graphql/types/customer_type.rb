# frozen_string_literal: true

module Types
  class CustomerType < Types::BaseObject
    field :id, String, null: false
    field :subscriptions, [SubscriptionType], null: false
  end
end
