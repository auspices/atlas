# frozen_string_literal: true

module Mutations
  class UnsubscribeFromProduct < BaseMutation
    argument :subscription_id, String, required: true

    field :user, Types::UserType, null: false

    def resolve(subscription_id:)
      begin
        Stripe::Subscription.update(subscription_id, { cancel_at_period_end: true })
      rescue StandardError => e
        return Errors::BadRequestError.new(e.message || e.error.message)
      end

      { user: current_user }
    end
  end
end
