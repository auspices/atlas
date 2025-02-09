# frozen_string_literal: true

class ResizedImage
  attr_reader :image, :width, :height, :factor, :ratio, :quality, :blur, :sharpen, :fit

  BUCKET = ENV.fetch('S3_BUCKET', nil)
  ENDPOINT = ENV.fetch('IMAGE_RESIZING_PROXY_ENDPOINT', nil)
  DEFAULT_SCALE = 1.0
  DEFAULT_QUALITY = 75
  DEFAULT_FIT = 'inside'

  # rubocop:disable Metrics/AbcSize
  def initialize(image, options = {})
    @image = image
    @fit = options[:fit] || DEFAULT_FIT

    raise ArgumentError, 'either `width` or `height` is required' if fit == 'inside' && !(options[:width] || options[:height])
    raise ArgumentError, 'both `width` and `height` are required' if fit == 'cover' && !(options[:width] && options[:height])

    # Resized properties
    @factor = [
      ((options[:width] / @image.width.to_f) if options[:width]),
      ((options[:height] / @image.height.to_f) if options[:height])
    ].compact.min

    scale = options[:scale] || DEFAULT_SCALE

    @width = @fit == 'cover' ? options[:width] : ([(@image.width * factor), @image.width].min * scale).to_i
    @height = @fit == 'cover' ? options[:height] : ([(@image.height * factor), @image.height].min * scale).to_i

    @ratio = (@height / @width.to_f * 100.0)

    # Additional transformations
    @quality = options[:quality] || DEFAULT_QUALITY
    @blur = options[:blur]
    @sharpen = options[:sharpen]
  end
  # rubocop:enable Metrics/AbcSize

  def size(factor = 1)
    edits = {
      resize: {
        width: width * factor,
        height: height * factor,
        fit:
      },
      webp: { quality: },
      jpeg: { quality: },
      # Passing `null` to the `rotate` filter utilizes the EXIF orientation
      rotate: nil
    }
            .merge(blur.present? ? { blur: } : {})
            .merge(sharpen.present? ? { sharpen: } : {})

    payload = {
      bucket: BUCKET,
      key: image.uri.path.delete_prefix('/'),
      edits:
    }.to_json

    [ENDPOINT, Base64.strict_encode64(payload)].join('/')
  end

  private

  def method_missing(method, *, &)
    image.send(method, *, &) || super
  end

  def respond_to_missing?(method_name, include_private = false)
    super
  end
end
