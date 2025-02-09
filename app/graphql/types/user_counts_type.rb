# frozen_string_literal: true

module Types
  class UserCountsType < Types::BaseObject
    field :collections, Int, null: false

    field :contents, Int, null: false

    def collections
      object.collections.size
    end

    def contents
      object.contents.size
    end
  end
end
