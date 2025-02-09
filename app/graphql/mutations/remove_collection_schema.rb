# frozen_string_literal: true

module Mutations
  class RemoveCollectionSchema < BaseMutation
    description 'Removes the schema from a collection'

    argument :id, ID, required: true,
                    description: 'ID of the collection to update'

    field :collection, Types::CollectionType, null: true

    def resolve(id:)
      collection = current_user.collections.friendly.find(id)

      if collection.update(schema: nil)
        { collection: collection }
      else
        raise GraphQL::ExecutionError.new(
          'Collection schema could not be removed',
          extensions: { errors: collection.errors.full_messages }
        )
      end
    end
  end
end
