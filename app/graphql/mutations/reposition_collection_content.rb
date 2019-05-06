# frozen_string_literal: true

module Mutations
  class RepositionCollectionContent < BaseMutation
    argument :connection, Types::ConnectionInput, required: true
    argument :action, Types::ReorderAction, required: true
    argument :insert_at, Int, required: false

    field :collection, Types::CollectionType, null: false

    def resolve(connection:, action:, insert_at: nil)
      collection = current_user.collections.find(connection.collection_id)
      connection = collection.connections.find_by!(
        image_id: connection.content_id
      )

      args = [action, insert_at].compact
      connection.send(*args)

      { collection: collection }
    end
  end
end
