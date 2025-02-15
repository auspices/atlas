# frozen_string_literal: true

module Mutations
  class UpdateCollection < BaseMutation
    argument :id, ID, required: true
    argument :metadata, GraphQL::Types::JSON, required: false, prepare: lambda { |metadata, _ctx|
      JSON.parse(metadata)
    }
    argument :replace, Boolean, required: false, default_value: false
    argument :title, String, required: false

    field :collection, Types::CollectionType, null: false

    def resolve(id:, replace:, title: nil, metadata: {})
      collection = current_user.collections.find(id)
      next_metadata = (replace ? metadata : collection.metadata.merge(metadata).compact)
                      .reject { |k, _| k.blank? } # Empty keys removes fields

      collection.update!({
        title:,
        metadata: next_metadata
      }.compact)

      { collection: }
    end
  end
end
