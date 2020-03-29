# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: false

    def me
      current_user
    end

    field :user, Types::UserType, null: false, deprecation_reason: 'Moving all query underneath logged in user' do
      argument :id, ID, required: true
    end

    def user(id:)
      User.friendly.find(id)
    end

    field :collection, Types::CollectionType, null: false, deprecation_reason: 'Moving all query underneath logged in user' do
      argument :id, ID, required: true
    end

    def collection(id:)
      Collection.friendly.find(id)
    end

    field :content, Types::ContentType, null: false, deprecation_reason: 'Moving all query underneath logged in user' do
      argument :id, ID, required: true
    end

    def content(id:)
      Content.find(id)
    end
  end
end
