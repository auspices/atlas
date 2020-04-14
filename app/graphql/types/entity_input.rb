# frozen_string_literal: true

module Types
  class EntityInput < BaseInputObject
    description 'Attributes for finding an Entity'
    argument :id, ID, 'ID of Entity', required: true
    argument :type, Types::EntityTypes, 'Kind of Entity', required: true
  end
end
