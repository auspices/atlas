# frozen_string_literal: true

module Types
  class ContentType < Types::BaseObject
    include Shared::Timestamps
    include Shared::Metadata
    include Shared::Href

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

    field :next, Types::ContentType, null: true

    def next
      Content.where(collection_id: object.collection_id).where('position > ?', object.position).order(position: :asc).first
    end

    field :previous, Types::ContentType, null: true

    def previous
      Content.where(collection_id: object.collection_id).where('position < ?', object.position).order(position: :desc).first
    end
  end
end
