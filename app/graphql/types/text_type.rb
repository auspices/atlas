# frozen_string_literal: true

module Types
  class TextType < Types::BaseObject
    include Shared::Timestamps
    include Shared::ToString

    field :id, Int, null: false
    field :body, String, null: false
    field :name, String, null: false, method: :to_s
  end
end
