# frozen_string_literal: true

module Uploadable
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_upload, if: proc { |model| model.url.present? }

    def self.key(url)
      URI.parse(url).path[1..-1]
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
end
