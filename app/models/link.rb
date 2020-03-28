# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id         :bigint           not null, primary key
#  url        :text
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Link < ApplicationRecord
  include StringHelper

  has_many :contents, as: :entity, dependent: :destroy
  has_many :collections, through: :contents
  belongs_to :user

  validates :user, :url, presence: true
  validates_format_of :url, with: URI.regexp(%w[http https])

  def uri
    @uri ||= Addressable::URI.heuristic_parse(url)
  end

  def to_s
    @to_s ||= normalize_url(url)
  end
end
