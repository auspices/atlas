# frozen_string_literal: true

module Mutations
  class AddEntityFromContentToCollection < BaseMutation
    argument :content_id, ID, required: true, description: 'Content ID'
    argument :id, ID, required: true, description: 'Collection ID'

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def resolve(id:, content_id:)
      collection = current_user.collections.find(id)
      existing_content = current_user.contents.find(content_id)
      entity = existing_content.entity
      content = collection.contents.create!(user: current_user, entity:)

      {
        collection:,
        content:,
        entity:
      }
    end
  end
end
