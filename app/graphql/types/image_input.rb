# frozen_string_literal: true

module Types
  class ImageInput < BaseInputObject
    description 'Input needed to create an Image'

    argument :url, String, 'URL to image file', required: true
  end
end
