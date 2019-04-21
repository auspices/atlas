# frozen_string_literal: true

module Mutations
  class RemoveFromCollection < BaseMutation
    argument :connection, Types::ConnectionInput, required: true

    field :collection, Types::CollectionType, null: false

    def resolve(connection:)
      collection = current_user.collections.find(connection.collection_id)
      content_connection = collection.connections.find_by!(
        image_id: connection.content_id
      )

      content_or_connection = if content_connection.content.collections.size == 1
        content_connection.content
      else
        content_connection
      end

      content_or_connection.destroy

      { collection: collection }
    end
  end
end
