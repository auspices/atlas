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
      begin
        object = bucket.objects[key]
        puts "Opening: #{url}"
        object.write(open(url).read, acl: :public_read)
        object.public_url.to_s
      rescue => e
        puts e
      end
    end

    def delete(key)
      begin
        s3_object(key).delete
      rescue => e
        puts e
      end
    end
  end
end
