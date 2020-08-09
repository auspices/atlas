# frozen_string_literal: true

module Types
  class CustomerType < Types::BaseObject
    field :id, String, null: false
    field :subscriptions, [SubscriptionType], null: false

    field :plans, [Types::PlanType], null: false

    def plans
      Stripe::Plan.list(limit: 10)
    end
  end
end
