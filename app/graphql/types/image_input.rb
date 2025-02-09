# frozen_string_literal: true

module Types
  class ImageInput < BaseInputObject
    description 'Input needed to create an Image'

    argument :file_content_length, Int, 'Filesize in bytes', required: true
    argument :file_content_type, String, 'Content-type (MIME) of file', required: true
    argument :file_name, String, 'Name of file', required: true
    argument :url, String, 'URL to image file', required: true
  end
end
