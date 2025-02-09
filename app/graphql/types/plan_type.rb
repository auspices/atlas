# frozen_string_literal: true

module Types
  class PlanType < Types::BaseObject
    field :amount, String, null: false, extensions: [Extensions::CurrencyExtension]
    field :id, String, null: false
    field :interval, PlanIntervalType, null: false
  end
end
