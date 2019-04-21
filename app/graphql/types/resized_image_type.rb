# frozen_string_literal: true

module Types
  class ResizedImageType < Types::BaseObject
    field :width, Int, null: true
    field :height, Int, null: true

    field :urls, Types::RetinaImageType, null: false

    def urls
      RetinaImage.new(object)
    end

    field :url, String, null: false

    def url
      object.size(1)
    end
  end
end
