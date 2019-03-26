# frozen_string_literal: true

module Types
  class CollectionType < Types::BaseObject
    field :id, Int, null: false
    field :slug, String, null: false
    field :title, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false

    field :images, [Types::ImageType], null: true

    def images
      object.images
    end
  end
end
