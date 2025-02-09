# frozen_string_literal: true

module Mutations
  class UpdateCollectionSchema < BaseMutation
    description 'Updates the schema for a collection'

    argument :id, ID, required: true,
                    description: 'ID of the collection to update'
    argument :schema_fields, [Types::SchemaFieldInputType], required: true,
                                                           description: 'Schema fields to set'

    field :collection, Types::CollectionType, null: true

    def resolve(id:, schema_fields:)
      collection = current_user.collections.friendly.find(id)

      schema = {
        'fields' => schema_fields.each_with_object({}) do |field, acc|
          acc[field.name] = {
            'type' => field.type,
            'required' => field.required
          }
        end
      }

      if collection.update(schema: schema)
        { collection: collection }
      else
        raise GraphQL::ExecutionError.new(
          'Collection schema could not be updated',
          extensions: { errors: collection.errors.full_messages }
        )
      end
    end
  end
end
