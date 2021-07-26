# frozen_string_literal: true

module Types
  class UploadInput < BaseInputObject
    description 'Input needed to create an Upload'

    argument :name, String, 'File name', required: true
    argument :type, String, 'File MIME type', required: true
  end
end
