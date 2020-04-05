# frozen_string_literal: true

module Types
  class ObjectType < Types::BaseUnion
    possible_types Types::CollectionType

    def self.resolve_type(object, _context)
      case object
      when Collection
        Types::CollectionType
      end
    end
  end
end
