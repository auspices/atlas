# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login

    field :create_collection, mutation: Mutations::CreateCollection
    field :update_collection, mutation: Mutations::UpdateCollection

    field :add_to_collection, mutation: Mutations::AddToCollection
    field :remove_from_collection, mutation: Mutations::RemoveFromCollection
    field :reposition_collection_content, mutation: Mutations::RepositionCollectionContent
    field :update_content, mutation: Mutations::UpdateContent
  end
end
