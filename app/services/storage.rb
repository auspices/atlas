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

    def store(url, key)
      object = bucket.objects[key]
      object.write(open(url).read, acl: :public_read)
      object.public_url.to_s
    end

    def delete(key)
      s3_object(key).delete
    end
  end
end
