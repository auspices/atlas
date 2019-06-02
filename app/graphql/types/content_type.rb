# frozen_string_literal: true

module Types
  class ContentType < Types::BaseObject
    include Shared::Timestamps

    field :id, Int, null: false
    field :position, Int, null: false

    field :entity, Types::EntityType, null: false

    def entity
      BatchLoader::GraphQL.for(object.entity_id).batch(key: object.entity_type) do |ids, loader, args|
        args[:key].constantize.where(id: ids).each { |entity| loader.call(entity.id, entity) }
      end
    end

    field :collection, Types::CollectionType, null: false

    def collection
      BatchLoader::GraphQL.for(object.collection_id).batch do |ids, loader|
        Collection.where(id: ids).each { |xs| loader.call(xs.id, xs) }
      end
    end
  end
end
