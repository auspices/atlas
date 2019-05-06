# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  connections_count :integer          default("0")
#  user_id           :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#  slug              :string(255)
#

class Collection < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :user

  validates :title, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :connections, -> { order position: :asc }, dependent: :destroy
  has_many :images, through: :connections

  def to_s
    title
  end

  # TODO: Aliases `contents` to `images` as we do not have distinct content types yet.
  alias contents images
end
