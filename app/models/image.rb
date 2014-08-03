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
  validates_presence_of :source_url

  after_create :store!
  before_destroy :remove!

  def store!
    self.update_attributes!(url: ImageMover.new(self).move!)
  end

  def url_key
    URI.parse(url).path[1..-1]
  end

  def remove!
    Storage.delete(url_key)
  end
end
