# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    include Shared::Timestamps

    field :id, Int, null: false
    field :title, String, null: false, method: :to_s
    field :name, String, null: false, method: :to_s
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
      # TODO: Validate that either width or height is present
      object.resized(width: width, height: height, scale: scale)
    end
  end
end
