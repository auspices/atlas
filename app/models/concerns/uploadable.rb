# frozen_string_literal: true

module Uploadable
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_upload, if: proc { |model| model.url.present? }
  end

  def key
    URI.parse(url).path[1..-1]
  end

  def upload
    @upload ||= UploadManager.new(key)
  end

  def delete_upload
    upload.delete
  end
end
