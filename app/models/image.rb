# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  url        :text
#  source_url :text
#  created_at :datetime
#  updated_at :datetime
#

class Image < ActiveRecord::Base
  after_create :store!, if: proc { |image| image.url.blank? }
  before_destroy :remove_s3_object!

  belongs_to :user

  validates_presence_of :source_url
  validates_presence_of :user_id

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
