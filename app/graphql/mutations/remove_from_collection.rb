# frozen_string_literal: true

module Mutations
  class RemoveFromCollection < BaseMutation
    argument :content_id, ID, required: true

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false

    def resolve(content_id:)
      content = Content.find(content_id)
      content.destroy

      { content:, collection: content.collection }
    end
  end
end
