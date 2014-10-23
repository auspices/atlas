class ImageProxyUrl
  attr_reader :options

  PROXY_URL = 'http://pale.auspic.es'

  QUERY_PARAMS = %i(url h w)

  def initialize(options = {})
    raise 'Requires :url' if options[:url].blank?
    options[:url] = CGI.escape(options[:url])
    @options = options
      .send(:extract!, *QUERY_PARAMS)
      .reverse_merge!(
        h: 1000,
        w: 1000
      )
  end

  def url
    "#{PROXY_URL}/resize/#{options[:w]}/#{options[:h]}/#{options[:url]}"
  end
end
