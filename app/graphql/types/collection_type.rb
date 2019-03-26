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

    field :contents, [Types::ContentType], null: true

    def contents
      object.contents
    end

    field :sample, [Types::ContentType], null: true do
      argument :amount, Int, required: false
    end

    def sample(amount: 1)
      object.contents.unscope(:order).order('RANDOM()').limit(amount)
    end
  end
end
