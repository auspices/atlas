# frozen_string_literal: true

module Mutations
  class AddToCollection < BaseMutation
    argument :id, ID, required: true, description: 'The ID of the desired collection'
    argument :source_url, String, required: true

    field :collection, Types::CollectionType, null: false
    field :content, Types::ContentType, null: false

    def resolve(id:, source_url:) # rubocop:disable Metrics/AbcSize
      collection = current_user.collections.find(id)

      ActiveRecord::Base.transaction do
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

        image.save!

        connection = Connector.build(current_user, collection, image)
        connection.save!

        return { collection: collection, content: image }
      end
    end
  end
end
