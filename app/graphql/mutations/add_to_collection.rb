# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :id, ID, required: true, description: 'Collection ID'
    argument :value, String, required: true, description: 'URL or plain text'

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def resolve(id:, value:)
      collection = current_user.collections.find(id)

      ActiveRecord::Base.transaction do
        entity = EntityBuilder.build(user: current_user, value: value)
        entity.save!

        content = collection.contents.create!(user: current_user, entity: entity)

        return {
          collection: collection,
          content: content,
          entity: entity
        }
      end
    end
  end
end
