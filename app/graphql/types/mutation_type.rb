# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login

    field :create_collection, mutation: Mutations::CreateCollection
    field :add_to_collection, mutation: Mutations::AddToCollection
    field :remove_from_collection, mutation: Mutations::RemoveFromCollection
  end
end
