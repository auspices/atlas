# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    field :id, String, null: false
    field :plan, PlanType, null: false
  end
end
