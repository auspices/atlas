# frozen_string_literal: true

module Types
  class CollectionCountsType < Types::BaseObject
    field :contents, Int, null: false

    def contents
      object.connections.size
    end
  end
end
