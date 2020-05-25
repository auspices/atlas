# frozen_string_literal: true

class ResizedImage
  attr_reader :image, :width, :height, :factor, :ratio, :quality

  BUCKET = ENV['S3_BUCKET']
  ENDPOINT = ENV['IMAGE_RESIZING_PROXY_ENDPOINT']
  DEFAULT_SCALE = 1.0
  DEFAULT_QUALITY = 75

  # rubocop:disable Metrics/AbcSize
  def initialize(image, options = {})
    scale = options[:scale] || DEFAULT_SCALE
    @quality = options[:quality] || DEFAULT_QUALITY
    @image = image
    @factor = [
      ((options[:width] / @image.width.to_f) if options[:width]),
      ((options[:height] / @image.height.to_f) if options[:height])
    ].compact.min
    @width = ([(@image.width * factor), @image.width].min * scale).to_i
    @height = ([(@image.height * factor), @image.height].min * scale).to_i
    @ratio = (@height / @width.to_f * 100.0)
  end
  # rubocop:enable Metrics/AbcSize

  def size(factor = 1)
    payload = {
      bucket: BUCKET,
      key: image.uri.path.delete_prefix('/'),
      edits: {
        resize: {
          width: width * factor,
          height: height * factor,
          fit: 'inside'
        },
        webp: { quality: quality },
        jpeg: { quality: quality },
        png: { quality: quality }
      }
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
