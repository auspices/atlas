# frozen_string_literal: true

module Mutations
  class AddEntityToCollection < BaseMutation
    argument :entity, Types::EntityInput, required: true
    argument :id, ID, required: true, description: 'Collection ID'

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def resolve(id:, entity:)
      collection = current_user.collections.find(id)
      method = entity.type.name.downcase.underscore.pluralize.to_sym
      entity = current_user.send(method).find(entity.id)
      content = collection.contents.create!(user: current_user, entity:)

      {
        collection:,
        content:,
        entity:
      }
    end
  end
end
