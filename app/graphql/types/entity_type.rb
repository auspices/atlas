# frozen_string_literal: true

module Types
  class EntityType < Types::BaseUnion
    possible_types Types::ImageType

    def self.resolve_type(object, _context)
      case object
      when Image
        Types::ImageType
      end
    end
  end
end
