# frozen_string_literal: true

module Mutations
  class CreateCollection < BaseMutation
    argument :title, String, required: true

    field :collection, Types::CollectionType, null: false

    def resolve(title:)
      collection = current_user.collections.create!(title:)

      { collection: }
    end
  end
end
