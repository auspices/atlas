# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    field :id, String, null: false
    field :plan, PlanType, null: false
    field :cancel_at_period_end, Boolean, null: false

    field :current_period_end_at, String, null: false, extensions: [Extensions::DateExtension]
    field :current_period_start_at, String, null: false, extensions: [Extensions::DateExtension]

    def current_period_end_at(**_args)
      Time.zone.at(object.current_period_end)
    end

    def current_period_start_at(**_args)
      Time.zone.at(object.current_period_start)
    end
  end
end
