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
      File.extname(url).downcase
    ]
      .compact
      .reject(&:empty?)
      .join ''
  end

  def move!
    Storage.store(url, key)
  end
end
