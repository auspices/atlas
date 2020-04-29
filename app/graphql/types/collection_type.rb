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

    field :counts, Types::CollectionCountsType, null: false

    def counts
      object
    end

    field :contents, [Types::ContentType], null: false do
      argument :page, Int, required: false
      argument :per, Int, required: false
      argument :metadata, GraphQL::Types::JSON, required: false
      argument :sort_by, Types::ContentsSortType, required: false
    end

    def contents(page: nil, per: nil, metadata: nil, sort_by: nil)
      results = object.contents
      results = results.unscope(:order).order(sort_by) if sort_by.present?
      results = results.where('metadata @> ?', metadata.to_json) if metadata.present?
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
    end
  end
end
