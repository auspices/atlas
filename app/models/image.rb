# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  url                 :text
#  source_url          :text
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  width               :integer
#  height              :integer
#  file_name           :text
#  file_content_type   :string
#  file_content_length :integer
#

class Image < ApplicationRecord
  include Uploadable

  has_many :contents, as: :entity, dependent: :destroy
  has_many :collections, through: :contents
  belongs_to :user

  validates :source_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }

  def to_s
    @to_s ||= if file_name?
      file_name
    elsif source_url.present? || url.present?
      File.basename(source_url || url)
    else
      'image'
    end
  end

  def uri
    @uri ||= Addressable::URI.parse(url)
  end

  def resized(options = {})
    ResizedImage.new(self, options)
  end
end
