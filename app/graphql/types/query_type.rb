# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: true

    def me
      current_user
    end

    field :user, Types::UserType, null: true do
      argument :id, ID, required: true
    end

    def user(id:)
      User.friendly.find(id)
    end

    field :collection, Types::CollectionType, null: true do
      argument :id, ID, required: true
    end

    def collection(id:)
      Collection.friendly.find(id)
    end

    field :content, Types::ContentType, null: true do
      argument :id, ID, required: true
      argument :type, Types::ContentTypes, required: true
    end

    def content(id:, type:)
      type.find(id)
    end
  end
end
