# frozen_string_literal: true

module Types
  class EntityType < Types::BaseUnion
    possible_types Types::ImageType, Types::TextType

    def self.resolve_type(object, _context)
      case object
      when Image
        Types::ImageType
      when Text
        Types::TextType
      end
    end
  end
end
