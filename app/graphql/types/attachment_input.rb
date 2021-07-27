# frozen_string_literal: true

module Types
  class AttachmentInput < BaseInputObject
    description 'Input needed to create an Attachment'

    argument :url, String, 'URL to file', required: true
    argument :file_name, String, 'Name of file', required: true
    argument :file_content_type, String, 'Content-type (MIME) of file', required: true
    argument :file_content_length, Int, 'Filesize in bytes', required: true
  end
end
