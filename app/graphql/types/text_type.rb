# frozen_string_literal: true

module Types
  class TextType < Types::BaseObject
    include Shared::Timestamps

    field :id, Int, null: false
    field :body, String, null: false
  end
end
