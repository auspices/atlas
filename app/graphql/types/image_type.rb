# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :id, Int, null: false
    field :title, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :source_url, String, null: true
    field :width, Int, null: true
    field :height, Int, null: true
    field :url, String, null: true

    field :resized, Types::ResizedImageType, null: true do
      argument :width, Int, required: false
      argument :height, Int, required: false
      argument :scale, Float, required: false
    end

    def resized(width: nil, height: nil, scale: nil)
      object.resized(width: width, height: height, scale: scale)
    end
  end
end
