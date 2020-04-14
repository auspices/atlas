# frozen_string_literal: true

module Types
  class EntityType < Types::BaseUnion
    possible_types Types::ImageType, Types::TextType, Types::LinkType, Types::CollectionType

    def self.resolve_type(object, _context)
      case object
      when Image
        Types::ImageType
      when Text
        Types::TextType
      when Link
        Types::LinkType
      when Collection
        Types::CollectionType
      end
    end
  end
end
