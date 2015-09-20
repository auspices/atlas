class ImageProxyUrl
  attr_reader :options

  PROXY_URL = 'http://pale.auspic.es'

  QUERY_PARAMS = %i(url height width)

  def initialize(options = {})
    fail 'Requires :url' if options[:url].blank?
    options[:url] = CGI.escape(options[:url])
    @options = options
      .send(:extract!, *QUERY_PARAMS)
      .reverse_merge!(
        width: 1000,
        height: 1000
      )
  end

  def url
    "#{PROXY_URL}/resize/#{options[:width]}/#{options[:height]}/#{options[:url]}"
  end
end
