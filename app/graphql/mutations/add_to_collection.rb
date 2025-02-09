# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :attachment, Types::AttachmentInput, required: false, description: 'Upload an attachment directly'
    argument :id, ID, required: true, description: 'Collection ID'
    argument :image, Types::ImageInput, required: false, description: 'Upload an image directly'
    argument :metadata, GraphQL::Types::JSON, required: false, prepare: lambda { |metadata, _ctx|
      JSON.parse(metadata)
    }
    argument :value, String, required: false, description: 'URL or plain text'

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def resolve(id:, value: nil, image: nil, attachment: nil, metadata: nil)
      collection = current_user.collections.find(id)

      return Errors::BadRequestError.new('Requires `image`, `attachment`, or `value`') if (image || attachment || value).blank?

      ActiveRecord::Base.transaction do
        entity = if image
          Entity::Builder.build_image(user: current_user, image:)
        elsif attachment
          Entity::Builder.build_attachment(user: current_user, attachment:)
        else
          Entity::Builder.build(user: current_user, value:)
        end

        entity.save!

        options = { user: current_user, entity:, metadata: }.compact
        content = collection.contents.create!(options)

        return {
          collection:,
          content:,
          entity:
        }
      end
    end
  end
end
