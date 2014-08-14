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
#

class Image < ActiveRecord::Base
  after_create :store!, if: proc { |image| image.url.blank? }
  before_destroy :remove_s3_object!, if: proc { |image| image.url.present? }

  has_many :connections
  has_many :collections, through: :connections
  belongs_to :user

  validates_format_of :source_url, with: URI::regexp(%w(http https))
  validates :source_url, presence: true
  validates :user_id, presence: true

  def store!
    self.update_attributes!(url: ImageMover.new(self).move!)
  end

  def url_key
    URI.parse(url).path[1..-1]
  end

  def remove_s3_object!
    Storage.delete(url_key)
  end
end
