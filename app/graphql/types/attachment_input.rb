# frozen_string_literal: true

module Types
  class AttachmentInput < BaseInputObject
    description 'Input needed to create an Attachment'

    argument :url, String, 'URL of file', required: true
    argument :name, String, 'Name of file', required: true
    argument :content_type, String, 'Content-type of file', required: true
    argument :content_length, String, 'Filesize in bytes', required: true
  end
end
