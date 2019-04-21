# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :id, ID, required: true, description: 'The ID of the desired collection'
    argument :source_url, String, required: true

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false

    def resolve(id:, source_url:)
      collection = current_user.collections.find(id)

      ActiveRecord::Base.transaction do
        image = current_user.images.create!(source_url: source_url)
        connection = Connector.build(current_user, collection, image)
        connection.save!

        return { collection: collection, content: image }
      end
    end
  end
end
