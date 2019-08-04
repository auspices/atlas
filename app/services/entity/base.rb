# frozen_string_literal: true

module Entity
  class Base
    SUPPORTED_SCHEMES = %w[http https].freeze

    attr_accessor :value

    def initialize(value:)
      @value = value
    end

    def uri
      @uri ||= Addressable::URI.heuristic_parse(value)
    end

    def url?
      SUPPORTED_SCHEMES.include?(uri.scheme)
    rescue Addressable::URI::InvalidURIError
      false
    end

    def image?
      !FastImage.type(value).nil?
    end
  end
end
