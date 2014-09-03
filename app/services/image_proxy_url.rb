class ImageProxyUrl
  attr_reader :options

  PROXY_URL = 'https://d1db8csqyunu31.cloudfront.net'

  QUERY_PARAMS = %i(url h w q)

  def initialize(options = {})
    raise 'Requires :url' if options[:url].blank?
    options[:url] = URI::encode(options[:url])
    @options = options
      .send(:extract!, *QUERY_PARAMS)
      .reverse_merge!(
        h: 1000,
        w: 1000,
        q: 90
      )
  end

  def url
    [PROXY_URL, '/resize?', options.to_query].join ''
  end
end
