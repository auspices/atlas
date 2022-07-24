# frozen_string_literal: true

module Types
  class ObjectQueryType < Types::BaseObject
    field :object, Types::CollectionType, null: false

    def object
      context[:collection]
    end
  end
end
