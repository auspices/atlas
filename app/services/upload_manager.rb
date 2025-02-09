# frozen_string_literal: true

require 'open-uri'
require 'aws-sdk-s3'

class UploadManager
  attr_reader :key

  S3_BUCKET = ENV.fetch('S3_BUCKET', nil)

  def initialize(key)
    @key = key
  end

  def s3
    @s3 ||= Aws::S3::Resource.new
  end

  def bucket
    @bucket ||= s3.bucket(S3_BUCKET)
  end

  def obj
    @obj ||= bucket.object(key)
  end

  def upload(io)
    obj.upload_stream(acl: 'public-read', content_type: io.content_type, cache_control: 'max-age=31536000') do |write_stream|
      IO.copy_stream(io, write_stream)
    end
  end

  delegate :delete, to: :obj

  def public_url
    obj.public_url(secure: true)
  end

  class << self
    def upload_from_source_url(source_url)
      uri = Addressable::URI.heuristic_parse(source_url)
      io = OpenURI.open_uri(uri)
      key = yield io
      uploader = new(key)

      begin
        uploader.upload(io)
      ensure
        io.close
      end

      uploader.public_url
    end

    def token
      SecureRandom.alphanumeric
    end

    def key(user_id:, filename:)
      [user_id, filename].join('/')
    end

    def presigned_url(mime_type:, user_id:, filename:)
      new(
        key(user_id:, filename:)
      ).obj.presigned_url(:put, acl: 'public-read', content_type: mime_type, cache_control: 'max-age=31536000')
    end

    def internal_url?(url, treat_duplicates_as_external: false)
      uri = Addressable::URI.heuristic_parse(url)
      is_internal = uri.host == "#{S3_BUCKET}.s3.amazonaws.com"

      return is_internal if is_internal == false

      return is_internal unless treat_duplicates_as_external

      is_internal && !Image.exists?(url:)
    rescue Addressable::URI::InvalidURIError
      false
    end
  end
end
