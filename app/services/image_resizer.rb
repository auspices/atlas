class ImageResizer
  attr_reader :image, :width, :height, :target_width, :target_height

  def self.valid_image?(image)
    !(image.width.nil? || image.height.nil?) ||
    image.width.try(:nonzero?) && image.height.try(:nonzero?)
  end

  def initialize(image, options = {})
    options.reverse_merge!(width: 0, height: 0)

    @image = image

    return unless self.class.valid_image?(image)

    @target_width = options[:width] || 0
    @target_height = options[:height] || 0

    options
      .map { |dimension, value| (value.to_f / image.send(dimension).to_f).nonzero? }
      .compact.min
      .tap { |ratio|
        ratio ||= 0

        @width = (image.width * ratio).to_i
        @height = (image.height * ratio).to_i
      }
  end

  def url
    @url ||= ImageProxyUrl.new(url: image.url, width: target_width, height: target_height).url
  end

  private

  def method_missing(method, *args, &block)
    image.send(method, *args, &block)
  end
end
