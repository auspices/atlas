# frozen_string_literal: true

module Types
  class CollectionType < Types::BaseObject
    include Shared::Timestamps
    include Shared::Metadata
    include Shared::ToString
    include Shared::Href

    field :id, Int, null: false
    field :key, String, null: true
    field :slug, String, null: false
    field :title, String, null: false
    field :name, String, null: false, method: :title
    field :schema, GraphQL::Types::JSON, null: true

    field :schema_fields, [Types::SchemaFieldType], null: false do
      argument :name, String, required: false
    end

    def schema_fields(name: nil)
      fields = object.schema_fields
      return [] if fields.empty?

      fields.filter_map do |field_name, field_def|
        next if name.present? && field_name != name

        field_def.merge('name' => field_name)
      end
    end

    field :counts, Types::CollectionCountsType, null: false

    def counts
      object
    end

    field :contents, [Types::ContentType], null: false do
      argument :page, Int, required: false
      argument :per, Int, required: false
      argument :metadata, GraphQL::Types::JSON, required: false
      argument :sort_by, Types::ContentsSortType, required: false
      argument :entity_type, Types::EntityTypes, required: false
    end

    def contents(page: nil, per: nil, metadata: nil, sort_by: nil, entity_type: nil)
      results = object.contents
      results = results.unscope(:order).order(sort_by) if sort_by.present?
      results = results.where('metadata @> ?', metadata.to_json) if metadata.present?
      results = results.where(entity_type: entity_type.to_s) if entity_type.present?
      results.page(page).per(per)
    end

    field :content, Types::ContentType, null: false do
      argument :id, ID, required: true
    end

    def content(id:)
      object.contents.find(id)
    end

    field :sample, [Types::ContentType], null: false do
      argument :amount, Int, required: false
    end

    def sample(amount: 1)
      object.contents.unscope(:order).order('RANDOM()').limit(amount)
    end

    field :collection, Types::CollectionType, null: false do
      argument :id, ID, required: true
    end

    def collection(id:)
      object.collections.friendly.find(id)
    rescue ActiveRecord::RecordNotFound
      Collection.find(id).tap do |target_collection|
        unless object.contains_collection?(target_collection.id)
          return Errors::NotFoundError.new("#{id} not contained within this collection")
        end
      end
    end

    field :within, [Types::CollectionType], null: false do
      argument :page, Int, required: false
      argument :per, Int, required: false
    end

    def within(page: nil, per: nil)
      ids = Content.where(entity_type: 'Collection', entity_id: object.id).pluck(:collection_id)
      Collection.where(id: ids).page(page).per(per)
    end
  end
end
