# frozen_string_literal: true

module Mutations
  class SubscribeToProduct < BaseMutation
    argument :product, Types::ProductsType, required: true

    field :user, Types::UserType, null: false

    def resolve(product:)
      current_user.subscribe_to!(product)

      { user: current_user }
    end
  end
end
