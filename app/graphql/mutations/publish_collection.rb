# frozen_string_literal: true

module Mutations
  class PublishCollection < BaseMutation
    argument :id, ID, required: true
    argument :regenerate, Boolean, required: false

    field :collection, Types::CollectionType, null: false

    def resolve(id:, regenerate: false)
      collection = current_user.collections.find(id)

      collection.update!(key: SecureRandom.uuid) if !collection.published? || regenerate

      { collection: }
    end
  end
end
