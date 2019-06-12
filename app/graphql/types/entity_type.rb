# frozen_string_literal: true

module Types
  class EntityType < Types::BaseUnion
    possible_types Types::ImageType, Types::TextType, Types::LinkType

    def self.resolve_type(object, _context)
      case object
      when Image
        Types::ImageType
      when Text
        Types::TextType
      when Link
        Types::LinkType
      end
    end
  end
end
