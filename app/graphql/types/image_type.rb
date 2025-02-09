# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    include Shared::Timestamps
    include Shared::ToString

    field :id, Int, null: false

    field :resized, Types::ResizedImageType, null: false do
      argument :blur, Int, required: false
      argument :fit, Types::ResizedImageFitType, required: false, default_value: 'inside'
      argument :height, Int, required: false
      argument :quality, Int, required: false
      argument :scale, Float, required: false
      argument :sharpen, Int, required: false
      argument :width, Int, required: false
    end

    field :height, Int, null: false
    field :name, String, null: false, method: :to_s
    field :source_url, String, null: true
    field :title, String, null: false, method: :to_s
    field :url, String, null: false, method: :static
    field :width, Int, null: false

    # rubocop:disable Metrics/ParameterLists
    def resized(width: nil, height: nil, scale: nil, quality: 75, blur: nil, sharpen: nil, fit: 'inside')
      object.resized(
        width:,
        height:,
        scale:,
        quality:,
        blur:,
        sharpen:,
        fit:
      )
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
