# frozen_string_literal: true

module Types
  class RetinaImageType < Types::BaseObject
    field :_1x, String, null: false
    field :_2x, String, null: false
    field :_3x, String, null: false
  end
end
