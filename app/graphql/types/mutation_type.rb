# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login
    field :register, mutation: Mutations::Register
    field :subscribe_to_product, mutation: Mutations::SubscribeToProduct
    field :unsubscribe_from_product, mutation: Mutations::UnsubscribeFromProduct
    field :reactivate_product_subscription, mutation: Mutations::ReactivateProductSubscription

    field :create_collection, mutation: Mutations::CreateCollection
    field :update_collection, mutation: Mutations::UpdateCollection
    field :delete_collection, mutation: Mutations::DeleteCollection
    field :publish_collection, mutation: Mutations::PublishCollection
    field :unpublish_collection, mutation: Mutations::UnpublishCollection
    field :update_collection_schema, mutation: Mutations::UpdateCollectionSchema
    field :remove_collection_schema, mutation: Mutations::RemoveCollectionSchema

    field :add_to_collection, mutation: Mutations::AddToCollection
    field :add_to_collections, mutation: Mutations::AddToCollections
    field :add_entity_to_collection, mutation: Mutations::AddEntityToCollection
    field :add_entity_from_content_to_collection, mutation: Mutations::AddEntityFromContentToCollection
    field :remove_from_collection, mutation: Mutations::RemoveFromCollection
    field :reposition_collection_content, mutation: Mutations::RepositionCollectionContent
    field :update_content, mutation: Mutations::UpdateContent
    field :update_entity, mutation: Mutations::UpdateEntity
  end
end
