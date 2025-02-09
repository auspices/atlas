# frozen_string_literal: true

module Types
  class ResizedImageType < Types::BaseObject
    field :height, Int, null: false
    field :width, Int, null: false

    field :url, String, null: false

    field :urls, Types::RetinaImageType, null: false

    def urls
      RetinaImage.new(object)
    end

    def url
      object.size(1)
    end
  end
end
