# frozen_string_literal: true
class ResizedImage
  attr_reader :image, :width, :height, :factor, :ratio

  ENDPOINT = ENV['IMAGE_RESIZING_PROXY_ENDPOINT'].freeze
  CANCER_SECRET_KEY = ENV['CANCER_SECRET_KEY'].freeze
  KEY_TEMPLATE = '<OP>/<WIDTH>x<HEIGHT>/<QUALITY>/<URL>'
  REQUEST_TEMPLATE = '<ENDPOINT>/<TOKEN>/<KEY>'
  DEFAULT_SCALE = 1.0
  DEFAULT_OP = 'resize'
  DEFAULT_QUALITY = 95

  def initialize(image, options = {})
    scale = options[:scale] || DEFAULT_SCALE
    @image = image
    @factor = [
      ((options[:width].to_f / @image.width.to_f) if options[:width]),
      ((options[:height].to_f / @image.height.to_f) if options[:height])
    ].compact.min
    @width = ([(@image.width * factor), @image.width].min * scale).to_i
    @height = ([(@image.height * factor), @image.height].min * scale).to_i
    @ratio = (@height.to_f / @width.to_f * 100.0)
  end

  def size(factor = 1)
    keyed = key(factor)
    REQUEST_TEMPLATE
      .gsub('<ENDPOINT>', ENDPOINT)
      .gsub('<TOKEN>', tokenize(keyed))
      .gsub('<KEY>', keyed)
  end

  def key(factor = 1)
    KEY_TEMPLATE
      .gsub('<OP>', DEFAULT_OP)
      .gsub('<WIDTH>', (width * factor).to_s)
      .gsub('<HEIGHT>', (height * factor).to_s)
      .gsub('<QUALITY>', DEFAULT_QUALITY.to_s)
      .gsub('<URL>', encode_uri_component(url))
  end

  def encode_uri_component(url)
    URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def tokenize(data)
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      CANCER_SECRET_KEY,
      data
    )
  end

  private

  def method_missing(method, *args, &block)
    image.send(method, *args, &block)
  end
end
