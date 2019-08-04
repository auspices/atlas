# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :id, ID, required: true, description: 'Collection ID'
    argument :value, String, required: true, description: 'URL or plain text'
    argument :metadata, GraphQL::Types::JSON, required: false, prepare: lambda { |metadata, _ctx|
      JSON.parse(metadata)
    }

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def resolve(id:, value:, metadata: nil)
      collection = current_user.collections.find(id)

      ActiveRecord::Base.transaction do
        entity = Entity::Builder.build(user: current_user, value: value)
        entity.save!

        options = { user: current_user, entity: entity, metadata: metadata }.compact
        content = collection.contents.create!(options)

        return {
          collection: collection,
          content: content,
          entity: entity
        }
      end
    end
  end
end
