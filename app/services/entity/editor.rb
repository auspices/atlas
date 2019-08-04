# frozen_string_literal: true

module Entity
  class Editor < Base
    class SupportError < StandardError; end

    attr_reader :entity

    def initialize(value:, entity:)
      @value = value
      @entity = entity
    end

    def edit
      case entity
      when Image
        edit_image
      when Text
        edit_text
      when Link
        edit_link
      else
        raise SupportError, "type of #{entity.class} is unsupported"
      end

      entity
    end

    def edit_image
      url = uri.to_s

      if UploadManager.internal_url?(url, treat_duplicates_as_external: true)
        edit_image_with_direct_upload(url)
      else
        edit_image_with_source_url(url)
      end
    end

    def edit_image_with_direct_upload(url)
      width, height = FastImage.size(url)

      entity.assign_attributes(
        url: url,
        width: width,
        height: height
      )
    end

    def edit_image_with_source_url(source_url)
      entity.assign_attributes(source_url: source_url)

      entity.url = UploadManager.upload_from_source_url(source_url) do |io|
        type = FastImage.type(io)

        raise CategorizationError, '`source_url` must be an image' if type.nil?

        width, height = FastImage.size(io)
        entity.assign_attributes(width: width, height: height)

        UploadManager.key(
          user_id: user.id,
          filename: "#{UploadManager.token}.#{type}"
        )
      end
    end

    def edit_text
      entity.assign_attributes(body: value)
    end

    def edit_link
      entity.assign_attributes(url: uri.to_s)
    end

    class << self
      def edit(entity:, value:)
        new(entity: entity, value: value).edit
      end
    end
  end
end
