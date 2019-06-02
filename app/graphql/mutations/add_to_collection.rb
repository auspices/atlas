# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :id, ID, required: true, description: 'The ID of the desired collection'
    argument :url, String, required: true

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false
    field :entity, Types::EntityType, null: false

    def build_image_with_direct_upload(url)
      width, height = FastImage.size(url)
      current_user.images.build(
        url: url,
        width: width,
        height: height
      )
    end

    def build_image_with_source_url(source_url)
      image = current_user.images.build(source_url: source_url)

      image.url = UploadManager.upload_from_source_url(source_url) do |io|
        type = FastImage.type(io)

        raise Errors::BadRequestError, '`source_url` must be an image' if type.nil?

        width, height = FastImage.size(io)
        image.assign_attributes(width: width, height: height)

        UploadManager.key(
          user_id: current_user.id,
          filename: "#{UploadManager.token}.#{type}"
        )
      end

      image
    end

    def resolve(id:, url:)
      collection = current_user.collections.find(id)

      ActiveRecord::Base.transaction do
        image = if UploadManager.internal_url?(url, treat_duplicates_as_external: true)
          build_image_with_direct_upload(url)
        else
          build_image_with_source_url(url)
        end

        image.save!

        content = collection.contents.create!(user: current_user, entity: image)

        return { collection: collection, content: content, entity: image }
      end
    end
  end
end
