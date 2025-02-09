# frozen_string_literal: true

module Mutations
  class SubscribeToProduct < BaseMutation
    argument :payment_method_id, String, required: true
    argument :price_id, String, required: true
    argument :product, Types::ProductsType, required: true

    field :user, Types::UserType, null: false

    def resolve(product:, payment_method_id:, price_id:)
      begin
        Stripe::PaymentMethod.attach(payment_method_id, { customer: current_user.customer_id })

        Stripe::Customer.update(current_user.customer_id,
                                invoice_settings: { default_payment_method: payment_method_id })

        subscription =
          Stripe::Subscription.create(
            customer: current_user.customer_id,
            items: [{ price: price_id }]
          )
      rescue StandardError => e
        return Errors::BadRequestError.new(e.message || e.error.message)
      end

      current_user.subscribe_to!(product) if %w[active trialing].include?(subscription.status)

      { user: current_user }
    end
  end
end
