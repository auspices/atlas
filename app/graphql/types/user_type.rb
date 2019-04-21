# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, Int, null: false
    field :username, String, null: false
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

    field :collections, [Types::CollectionType], null: true do
      argument :page, Int, required: false
      argument :per, Int, required: false
    end

    def collections(page: nil, per: nil)
      object.collections.page(page).per(per)
    end

    field :sample, [Types::ContentType], null: true do
      argument :amount, Int, required: false
    end

    def sample(amount: 1)
      object.contents.unscope(:order).order('RANDOM()').limit(amount)
    end
  end
end
