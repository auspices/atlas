# frozen_string_literal: true

module Types
  class PlanType < Types::BaseObject
    field :id, String, null: false
    field :amount, String, null: false, extensions: [Extensions::CurrencyExtension]
    field :interval, PlanIntervalType, null: false
  end
end
