# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id             :integer          not null, primary key
#  title          :string
#  contents_count :integer          default(0)
#  user_id        :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#  slug           :string
#  metadata       :jsonb            not null
#  key            :uuid
#

class Collection < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :user

  validates :title, :user, presence: true

  belongs_to :user
  has_many :contents, -> { order position: :asc }, dependent: :destroy

  has_many :collections, through: :contents, source: :entity, source_type: 'Collection'
  has_many :images, through: :contents, source: :entity, source_type: 'Image'
  has_many :texts, through: :contents, source: :entity, source_type: 'Text'
  has_many :links, through: :contents, source: :entity, source_type: 'Link'

  include HasUrl
  has_url template: -> { { segments: ['xs', slug] } }

  before_destroy do
    Content.where(entity_type: 'Collection', entity_id: id).destroy_all
  end

  def to_s
    title
  end

  def published?
    key?
  end
end
