# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    include Shared::Timestamps
    include Shared::ToString

    field :id, Int, null: false
    field :title, String, null: false, method: :to_s
    field :name, String, null: false, method: :to_s
    field :source_url, String, null: true
    field :width, Int, null: false
    field :height, Int, null: false
    field :url, String, null: false

    def url
      object.static
    end

    field :resized, Types::ResizedImageType, null: false do
      argument :width, Int, required: false
      argument :height, Int, required: false
      argument :scale, Float, required: false
      argument :quality, Int, required: false
      argument :blur, Int, required: false
      argument :sharpen, Int, required: false
    end

    # rubocop:disable Metrics/ParameterLists
    def resized(width: nil, height: nil, scale: nil, quality: 75, blur: nil, sharpen: nil)
      object.resized(
        width: width,
        height: height,
        scale: scale,
        quality: quality,
        blur: blur,
        sharpen: sharpen
      )
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
