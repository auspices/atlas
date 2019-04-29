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

  def presigned_url
    obj.presigned_url(:put, acl: 'public-read')
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
      rand(36**8).to_s(36)
    end

    TYPES = {
      image: 'images'
    }.freeze

    def key(type:, user_id:, filename:)
      [TYPES[type], user_id, filename].join('/')
    end
  end
end
