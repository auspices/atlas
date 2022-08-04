# frozen_string_literal: true

class ResizedImage
  attr_reader :image, :width, :height, :factor, :ratio, :quality, :blur, :sharpen, :fit

  BUCKET = ENV['S3_BUCKET']
  ENDPOINT = ENV['IMAGE_RESIZING_PROXY_ENDPOINT']
  DEFAULT_SCALE = 1.0
  DEFAULT_QUALITY = 75
  DEFAULT_FIT = 'inside'

  # rubocop:disable Metrics/AbcSize
  def initialize(image, options = {})
    @image = image

    # Resized properties
    @factor = [
      ((options[:width] / @image.width.to_f) if options[:width]),
      ((options[:height] / @image.height.to_f) if options[:height])
    ].compact.min

    scale = options[:scale] || DEFAULT_SCALE

    @width = ([(@image.width * factor), @image.width].min * scale).to_i
    @height = ([(@image.height * factor), @image.height].min * scale).to_i

    @ratio = (@height / @width.to_f * 100.0)

    # Additional transformations
    @quality = options[:quality] || DEFAULT_QUALITY
    @blur = options[:blur]
    @sharpen = options[:sharpen]
    @fit = options[:fit] || DEFAULT_FIT
  end
  # rubocop:enable Metrics/AbcSize

  def size(factor = 1)
    edits = {
      resize: {
        width: width * factor,
        height: height * factor,
        fit: fit
      },
      webp: { quality: quality },
      jpeg: { quality: quality },
      # Passing `null` to the `rotate` filter utilizes the EXIF orientation
      rotate: nil
    }
            .merge(blur.present? ? { blur: blur } : {})
            .merge(sharpen.present? ? { sharpen: sharpen } : {})

    payload = {
      bucket: BUCKET,
      key: image.uri.path.delete_prefix('/'),
      edits: edits
    }.to_json

    [ENDPOINT, Base64.strict_encode64(payload)].join('/')
  end

  private

  def method_missing(method, *args, &block)
    image.send(method, *args, &block) || super
  end

  def respond_to_missing?(method_name, include_private = false)
    super
  end
end
