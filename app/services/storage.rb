require 'open-uri'

module Storage
  class << self
    def connection
      @connection ||= Fog::Storage.new(
        aws_access_key_id: access_key_id,
        aws_secret_access_key: secret_access_key,
        provider: 'AWS'
      )
    end

    def bucket
      @bucket ||= connection.directories.get(s3_bucket)
    end

    def s3_bucket
      ENV['S3_BUCKET']
    end

    def access_key_id
      ENV['AWS_ACCESS_KEY_ID']
    end

    def secret_access_key
      ENV['AWS_SECRET_ACCESS_KEY']
    end

    def s3_object(key)
      bucket.files.get(key)
    end

    def mime_type(key)
      MIME::Types.type_for(key).first.to_s
    end

    def store(url, key)
      open(url) { |io|
        bucket.files.create(key: key, public: true, body: io.read).tap do |object|
          io.rewind
          yield io, object
        end
      }
    end

    def delete(key)
      s3_object(key).destroy
    end
  end
end
