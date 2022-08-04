# frozen_string_literal: true

module Mutations
  class RepositionCollectionContent < BaseMutation
    argument :content_id, ID, required: true
    argument :action, Types::ReorderAction, required: true
    argument :insert_at, Int, required: false

    field :content, Types::ContentType, null: false
    field :collection, Types::CollectionType, null: false

    def resolve(content_id:, action:, insert_at: nil)
      content = Content.find(content_id)

      args = [action, insert_at].compact
      content.send(*args)

      { content:, collection: content.collection }
    end
  end
end
