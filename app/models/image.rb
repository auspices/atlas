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

class Image < ActiveRecord::Base
  after_create :store!, if: proc { |image| image.url.blank? }
  before_destroy :remove_s3_object!, if: proc { |image| image.url.present? }

  has_many :connections, dependent: :destroy
  has_many :collections, through: :connections
  belongs_to :user

  validates_format_of :source_url, with: URI.regexp(%w[http https])
  validates :source_url, presence: true
  validates :user_id, presence: true
  validate :source_url_is_an_image

  def to_s
    File.basename(source_url)
  end

  def mover
    @mover ||= ImageMover.new(self)
  end

  def store!
    update_attributes!(mover.move!)
  end

  def source_url_is_an_image
    errors.add(:source_url, 'must be an image') unless mover.extension_valid?
  end

  def url_key
    URI.parse(url).path[1..-1]
  end

  def remove_s3_object!
    Storage.delete(url_key)
  end

  def resized(options)
    ImageResizer.new(self, options)
  end
end
