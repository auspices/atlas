# frozen_string_literal: true

class EntityBuilder
  class CategorizationError < StandardError; end

  SUPPORTED_SCHEMES = %w[http https].freeze

  attr_reader :user, :value

  def initialize(user:, value:)
    @user = user
    @value = value
  end

  def uri
    @uri ||= Addressable::URI.heuristic_parse(value)
  end

  def url?
    SUPPORTED_SCHEMES.include?(uri.scheme)
  rescue Addressable::URI::InvalidURIError
    false
  end

  def image?
    !FastImage.type(value).nil?
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
    width, height = FastImage.size(url)
    user.images.build(
      url: url,
      width: width,
      height: height
    )
  end

  def build_image_with_source_url(source_url)
    image = user.images.build(source_url: source_url)

    image.url = UploadManager.upload_from_source_url(source_url) do |io|
      type = FastImage.type(io)

      raise CategorizationError, '`source_url` must be an image' if type.nil?

      width, height = FastImage.size(io)
      image.assign_attributes(width: width, height: height)

      UploadManager.key(
        user_id: user.id,
        filename: "#{UploadManager.token}.#{type}"
      )
    end

    image
  end

  class << self
    def build(user:, value:)
      new(user: user, value: value).build
    end
  end
end
