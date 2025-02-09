# frozen_string_literal: true

module Types
  class SchemaFieldTypeEnum < Types::BaseEnum
    description 'Valid types for schema fields'

    Collection::VALID_SCHEMA_TYPES.each do |type|
      value type.upcase, value: type, description: "#{type.capitalize} type"
    end
  end
end
