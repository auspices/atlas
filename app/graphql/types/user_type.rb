# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, Int, null: false
    field :email, String, null: false
    field :slug, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false

    field :collection, Types::CollectionType, null: true do
      argument :id, ID, required: true
    end

    def collection(id:)
      object.collections.friendly.find(id)
    end

    field :collections, [Types::CollectionType], null: true

    def collections
      object.collections
    end
  end
end
