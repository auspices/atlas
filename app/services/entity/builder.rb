# frozen_string_literal: true

module Entity
  class Builder < Base
    class CategorizationError < StandardError; end

    attr_reader :user

    def initialize(value:, user:) # rubocop:disable Lint/MissingSuper
      @user = user
      @value = value
    end

    def build
      if url? && image?
        build_image
      elsif url?
        build_link
      else
        build_text
      end
    end

    def build_text
      user.texts.build(body: value)
    end

    def build_link
      user.links.build(url: uri.to_s)
    end

    def build_image
      url = uri.to_s

      if UploadManager.internal_url?(url, treat_duplicates_as_external: true)
        build_image_with_direct_upload(url)
      else
        build_image_with_source_url(url)
      end
    end

    def build_image_with_direct_upload(url)
      io = OpenURI.open_uri(url)
      width, height = FastImage.size(io)
      type = FastImage.type(io)
      io.rewind

      user.images.build(
        url:,
        width:,
        height:,
        file_name: File.basename(url),
        file_content_type: "image/#{type}",
        file_content_length: io.size
      )
    end

    def build_image_with_source_url(source_url)
      image = user.images.build(
        source_url:,
        file_name: File.basename(source_url)
      )

      image.url = UploadManager.upload_from_source_url(source_url) do |io|
        type = FastImage.type(io)

        raise CategorizationError, '`source_url` must be an image' if type.nil?

        width, height = FastImage.size(io)
        io.rewind

        image.assign_attributes(
          width:,
          height:,
          file_content_type: "image/#{type}",
          file_content_length: io.size
        )

        UploadManager.key(
          user_id: user.id,
          filename: "#{UploadManager.token}.#{type}"
        )
      end

      image
    end

    class << self
      def build(user:, value:)
        new(user:, value:).build
      end

      def build_image(user:, image:)
        width, height = FastImage.size(image[:url])

        user.images.build(
          width:,
          height:,
          url: image[:url],
          file_name: image[:file_name],
          file_content_type: image[:file_content_type],
          file_content_length: image[:file_content_length]
        )
      end

      def build_attachment(user:, attachment:)
        user.attachments.build(
          url: attachment[:url],
          file_name: attachment[:file_name],
          file_content_type: attachment[:file_content_type],
          file_content_length: attachment[:file_content_length]
        )
      end
    end
  end
end
