# frozen_string_literal: true

module Mutations
  class AddToCollections < BaseMutation
    argument :ids, [ID], required: true, description: 'Collection IDs'
    argument :metadata, GraphQL::Types::JSON, required: false, prepare: lambda { |metadata, _ctx|
      JSON.parse(metadata)
    }
    argument :value, String, required: true, description: 'URL or plain text'

    field :collections, [Types::CollectionType], null: false
    field :contents, [Types::ContentType], null: false
    field :entity, Types::EntityType, null: false

    def resolve(ids:, value:, metadata: nil)
      collections = current_user.collections.find(ids)

      ActiveRecord::Base.transaction do
        entity = Entity::Builder.build(user: current_user, value:)
        entity.save!

        options = { user: current_user, entity:, metadata: }.compact
        contents = collections.map do |collection|
          collection.contents.create!(options)
        end

        return {
          collections:,
          contents:,
          entity:
        }
      end
    end
  end
end
