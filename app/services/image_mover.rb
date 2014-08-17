class ImageMover
  attr_reader :image, :url

  def initialize(image)
    @image = image
    @url = image.source_url
    raise 'Requires source_url' if @url.blank?
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
    ext = File.extname(URI.parse(url).path).downcase
    ext.blank? ? fallback_extension : ext
  end

  def fallback_extension
    ".#{FastImage.type(url)}"
  end

  def move!
    Storage.store(url, key)
  end
end
