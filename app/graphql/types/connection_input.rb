# frozen_string_literal: true

module Types
  class ConnectionInput < BaseInputObject
    description 'Attributes for locating the connection of some content'

    argument :collection_id, ID, required: true
    argument :content_id, ID, required: true
    argument :content_type, Types::ContentTypes, required: true
  end
end
