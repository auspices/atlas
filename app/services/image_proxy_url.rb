class ImageProxyUrl
  attr_reader :source_url, :options

  QUERY_PARAMS = %i(h w q fit fm)

  def initialize(options = {})
    raise 'Requires :url' if options[:url].blank?
    @source_url = options[:url]
    @options = options
      .send(:extract!, *QUERY_PARAMS)
      .reverse_merge!(
        h: 1000,
        w: 1000,
        q: 95,
        fit: :max,
        fm: :pjpg
      )
  end

  def uri
    URI.parse(source_url).tap do |uri|
      uri.host.gsub!('.s3.amazonaws.com', '.imgix.net')
    end
  end

  def url
    [uri.to_s, '?', options.to_query].join ''
  end
end
