# frozen_string_literal: true

module Types
  class ObjectQueryType < Types::BaseObject
    field :object, Types::ObjectType, null: false

    def object
      context[:current_object]
    end
  end
end
