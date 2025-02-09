# frozen_string_literal: true

module Types
  class SchemaFieldInputType < Types::BaseInputObject
    description 'Attributes for a schema field'

    argument :name, String, required: true,
                          description: 'Name of the field'
    argument :required, Boolean, required: true,
                                description: 'Whether the field is required'
    argument :type, Types::SchemaFieldTypeEnum, required: true,
                          description: 'Type of the field'
  end
end
