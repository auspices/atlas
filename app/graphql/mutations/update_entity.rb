# frozen_string_literal: true

module Mutations
  class UpdateEntity < BaseMutation
    argument :id, ID, required: true
    argument :type, Types::EntityTypes, required: true
    argument :value, String, required: true, description: 'URL or plain text'

    field :entity, Types::EntityType, null: false

    def resolve(type:, id:, value:)
      entity = current_user.send(type.name.tableize.to_sym).find(id)

      ActiveRecord::Base.transaction do
        entity = Entity::Editor.edit(entity:, value:)
        entity.save!
      end

      { entity: }
    end
  end
end
