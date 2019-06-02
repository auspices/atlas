# frozen_string_literal: true

module Types
  class UserCountsType < Types::BaseObject
    field :collections, Int, null: false

    def collections
      object.collections.size
    end

    field :contents, Int, null: false

    def contents
      object.contents.size
    end
  end
end
