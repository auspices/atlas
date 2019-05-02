# frozen_string_literal: true

require 'open-uri'
require 'aws-sdk-s3'

class UploadManager
  attr_reader :key

  S3_BUCKET = ENV['S3_BUCKET']

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
    obj.upload_stream(acl: 'public-read') do |write_stream|
      IO.copy_stream(io, write_stream)
    end
  end

  def delete
    obj.delete
  end

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
        key(user_id: user_id, filename: filename)
      ).obj.presigned_url(:put, acl: 'public-read', content_type: mime_type)
    end

    def internal_url?(url)
      uri = Addressable::URI.heuristic_parse(url)
      uri.host == "#{S3_BUCKET}.s3.amazonaws.com"
    rescue Addressable::URI::InvalidURIError
      false
    end
  end
end
