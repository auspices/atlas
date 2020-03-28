# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    include Shared::Timestamps
    include Shared::ToString

    field :id, Int, null: false
    field :title, String, null: false, method: :to_s
    field :name, String, null: false, method: :to_s
    field :source_url, String, null: false
    field :width, Int, null: false
    field :height, Int, null: false
    field :url, String, null: false

    field :resized, Types::ResizedImageType, null: false do
      argument :width, Int, required: false
      argument :height, Int, required: false
      argument :scale, Float, required: false
    end

    def resized(width: nil, height: nil, scale: nil)
      # TODO: Validate that either width or height is present
      object.resized(width: width, height: height, scale: scale)
    end
  end
end
