require 'open-uri'

module Storage
  class << self
    def connection
      @connection ||= AWS::S3.new
    end

    def bucket
      @bucket ||= connection.buckets[ENV['S3_BUCKET']]
    end

    def s3_bucket
      ENV['S3_BUCKET']
    end

    def access_key_id
      ENV['AWS_ACCESS_KEY_ID']
    end

    def s3_object(key)
      bucket.objects[key]
    end

    def mime_type(key)
      MIME::Types.type_for(key).first.to_s
    end

    def store(url, key)
      open(url) { |io|
        content_type = io.content_type.present? ? io.content_type : mime_type(key)
        bucket.objects[key].tap do |object|
          object.write(io.read, acl: :public_read, content_type: content_type)
          io.rewind
          yield io, object
        end
      }
    end

    def delete(key)
      s3_object(key).delete
    end
  end
end
