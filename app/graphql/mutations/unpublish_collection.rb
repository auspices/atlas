# frozen_string_literal: true

module Mutations
  class UnpublishCollection < BaseMutation
    argument :id, ID, required: true

    field :collection, Types::CollectionType, null: false

    def resolve(id:)
      collection = current_user.collections.find(id)
      collection.update!(key: nil)

      { collection: }
    end
  end
end
