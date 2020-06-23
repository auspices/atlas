# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :id, ID, required: true, description: 'Collection ID'
    argument :value, String, required: false, description: 'URL or plain text'
    argument :image, Types::ImageInput, required: false, description: 'Upload an image directly'
    argument :attachment, Types::AttachmentInput, required: false, description: 'Upload an attachment directly'
    argument :metadata, GraphQL::Types::JSON, required: false, prepare: lambda { |metadata, _ctx|
      JSON.parse(metadata)
    }

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def resolve(id:, value: nil, image: nil, attachment: nil, metadata: nil)
      collection = current_user.collections.find(id)

      unless (image || attachment || value).present?
        # Needs to raise a better error
        raise 'bad request'
      end

      ActiveRecord::Base.transaction do
        entity = if image
          Entity::Builder.build_image(user: current_user, image: image)
        elsif attachment
          Entity::Builder.build_attachment(user: current_user, attachment: attachment)
        else
          Entity::Builder.build(user: current_user, value: value)
        end

        entity.save!

        options = { user: current_user, entity: entity, metadata: metadata }.compact
        content = collection.contents.create!(options)

        return {
          collection: collection,
          content: content,
          entity: entity
        }
      end
    end
  end
end
