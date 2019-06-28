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
  has_many :contents, as: :entity, dependent: :destroy
  has_many :collections, through: :contents
  belongs_to :user

  validates :user, :url, presence: true
  validates_format_of :url, with: URI.regexp(%w[http https])

  def uri
    @uri ||= Addressable::URI.heuristic_parse(url)
  end

  def truncated_url(length: 25)
    normalized = [uri.host, uri.path].reject(&:blank?).join('/').gsub(%r{\/+$}, '')
    return normalized if normalized.length <= length

    chars = normalized.gsub(/^www\./, '').chars
    head, tail = chars.each_slice((chars.size / 2.0).round).to_a
    head.join('').truncate(length / 2, separator: '…') + tail.last(length / 2).join('')
  end

  def to_s
    @to_s ||= truncated_url(length: 25)
  end
end
