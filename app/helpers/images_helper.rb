module ImagesHelper
  def resize(options = {})
    options.reverse_merge!(method: :resize)
    ImageProxyUrl.new(options).url
  end
end
