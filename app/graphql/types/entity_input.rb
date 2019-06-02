# frozen_string_literal: true

module Types
  class EntityInput < BaseInputObject
    argument :collection_id, ID, required: true
    argument :entity_id, ID, required: true
    argument :entity_type, Types::EntityTypes, required: true
  end
end
