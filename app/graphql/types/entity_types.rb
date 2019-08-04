# frozen_string_literal: true

module Types
  class EntityTypes < BaseEnum
    value 'IMAGE', value: Image
    value 'TEXT', value: Text
    value 'LINK', value: Link
  end
end
