# frozen_string_literal: true

class UrlBuilder
  PROTOCOL = 'https'
  HOST =
    case ENV.fetch('RAILS_ENV', nil)
    when 'production'
      'www.auspic.es'
    when 'test'
      'test.auspic.es'
    when 'development'
      'localhost:5001'
    else
      'www.auspic.es'
    end

  BASE_URL_TEMPLATE = Addressable::Template.new('{protocol}://{host}{/segments*}')
  EXPANDED_URL_TEMPLATE = BASE_URL_TEMPLATE.partial_expand(protocol: PROTOCOL, host: HOST)

  def initialize(absolute: true)
    @absolute = absolute
  end

  def absolute?
    @absolute
  end

  def to_uri(options = {})
    EXPANDED_URL_TEMPLATE.expand(options)
  end

  def to_s(options: {}, absolute: nil)
    uri = to_uri(options)

    return uri.path if absolute == false
    return uri.to_s if absolute || absolute?

    uri.path
  end
end
