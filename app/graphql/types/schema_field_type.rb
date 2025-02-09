# frozen_string_literal: true

module Types
  class SchemaFieldType < Types::BaseObject
    field :name, String, null: false
    field :required, Boolean, null: false
    field :type, Types::SchemaFieldTypeEnum, null: false
  end
end
