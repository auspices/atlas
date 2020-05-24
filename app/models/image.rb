# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  url        :text
#  source_url :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  width      :integer
#  height     :integer
#

class Image < ApplicationRecord
  include Uploadable

  has_many :contents, as: :entity, dependent: :destroy
  has_many :collections, through: :contents
  belongs_to :user

  validates_format_of :source_url, with: URI.regexp(%w[http https]), allow_blank: true
  validates_format_of :url, with: URI.regexp(%w[https]), allow_blank: true
  validates_uniqueness_of :url
  validates :user, presence: true

  def to_s
    @to_s ||= if source_url.present? || url.present?
      File.basename(source_url || url)
    else
      'image'
    end
  end

  def static
    if ENV['STATIC_CLOUDFRONT_ENDPOINT'].present?
      return url.gsub("#{ENV['S3_BUCKET']}.s3.amazonaws.com", ENV['STATIC_CLOUDFRONT_ENDPOINT'])
    end

    url
  end

  def resized(options = {})
    ResizedImage.new(self, options)
  end
end
