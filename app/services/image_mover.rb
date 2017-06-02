# frozen_string_literal: true

class ImageMover
  attr_reader :image, :url

  VALID_TYPES = %i[jpg jpeg gif png].freeze

  def initialize(image)
    @image = image
    @url = image.source_url
  end

  def key
    [
      image.id.to_s, '/',
      Digest::SHA256.hexdigest(url),
      extension
    ]
      .compact
      .reject(&:empty?)
      .join ''
  end

  def extension
    return nil unless url
    ext = File.extname(URI.parse(url).path).downcase
    ext.blank? ? fallback_extension : ext
  end

  def fallback_extension
    ".#{type}"
  end

  # For the time being, trust the extension
  def extension_valid?
    VALID_TYPES.include?(extension && extension[1..-1].to_sym)
  end

  def type
    @type ||= FastImage.type(url)
  end

  def move!
    Storage.store(url, key) do |io, object|
      width, height = FastImage.size(io)
      return {
        url: object.public_url.to_s,
        width: width,
        height: height
      }
    end
  end
end
