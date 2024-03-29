# frozen_string_literal: true

module Mutations
  class UpdateContent < BaseMutation
    argument :id, ID, required: true
    argument :metadata, GraphQL::Types::JSON, required: false, prepare: lambda { |metadata, _ctx|
      JSON.parse(metadata)
    }
    argument :replace, Boolean, required: false, default_value: false

    field :content, Types::ContentType, null: false

    def resolve(id:, replace:, title: nil, metadata: {})
      content = current_user.contents.find(id)
      next_metadata = (replace ? metadata : content.metadata.merge(metadata).compact)
                      .reject { |k, _| k.blank? } # Empty keys removes fields

      content.update!({
        title:,
        metadata: next_metadata
      }.compact)

      { content: }
    end
  end
end
