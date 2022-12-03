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

  def contains_collection?(target_collection_id, visited = Set.new)
    # If this collection has already been visited, return false to avoid loops.
    return false if visited.include?(self.id)
    visited.add(self.id)

    # Return true if this collection is the target collection.
    return true if self.id == target_collection_id

    # Check if any of the child collections contain the target collection.
    self.collections.any? do |child_collection|
      child_collection.contains_collection?(target_collection_id, visited)
    end
  end
end
