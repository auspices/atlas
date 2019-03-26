# frozen_string_literal: true

module Types
  class ResizedImageType < Types::BaseObject
    field :title, String, null: false
    field :width, Int, null: true
    field :height, Int, null: true
    field :urls, Types::RetinaImageType, null: true

    def urls
      RetinaImage.new(object)
    end
  end
end
