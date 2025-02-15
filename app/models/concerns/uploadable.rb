# frozen_string_literal: true

module Uploadable
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_upload, if: proc { |model| model.url.present? }

    validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[https]), allow_blank: true }
    validates :url, uniqueness: true

    def self.key(url)
      URI.parse(url).path[1..]
    end
  end

  def key
    self.class.key(url)
  end

  def upload
    @upload ||= UploadManager.new(key)
  end

  def delete_upload
    upload.delete
  end

  def static
    if ENV['STATIC_CLOUDFRONT_ENDPOINT'].present?
      return url.gsub("#{ENV.fetch('S3_BUCKET', nil)}.s3.amazonaws.com", ENV['STATIC_CLOUDFRONT_ENDPOINT'])
    end

    url
  end
end
