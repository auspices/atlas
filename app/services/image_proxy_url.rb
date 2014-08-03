class ImageProxyUrl
  attr_reader :method, :options

  QUERY_PARAMS = %i(url height width quality)

  def initialize(options = {})
    raise 'Requires :url' if options[:url].blank?
    options.reverse_merge!(method: :resize)
    @method = options[:method]
    @options = options
      .send(:extract!, *QUERY_PARAMS)
      .reverse_merge!(
        height: 1000,
        width: 1000,
        quality: 95,
        key: embedly_key
      )
  end

  def cloudfront_url
    ENV['CLOUDFRONT_URL']
  end

  def embedly_key
    ENV['EMBEDLY_KEY']
  end

  def embedly_endpoint(method)
    "/1/image/#{method}"
  end

  def url
    [
      cloudfront_url,
      embedly_endpoint(method),
      '?', options.to_query
    ].join ''
  end
end
