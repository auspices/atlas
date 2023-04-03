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

  has_many :attachments, through: :contents, source: :entity, source_type: 'Attachment'
  has_many :collections, through: :contents, source: :entity, source_type: 'Collection'
  has_many :images, through: :contents, source: :entity, source_type: 'Image'
  has_many :links, through: :contents, source: :entity, source_type: 'Link'
  has_many :texts, through: :contents, source: :entity, source_type: 'Text'

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

  def contains_collection?(target_collection_id)
    # Recursive Common Table Expression (CTE) to find nested collections
    cte_query = <<-SQL
      WITH RECURSIVE nested_collections AS (
        -- Base case: Select the root collection's ID and its directly nested collections
        SELECT collection_id, entity_id
        FROM contents
        WHERE collection_id = $1 AND entity_type = 'Collection'

        UNION ALL

        -- Recursive step: For each nested collection found in the previous step, find its nested collections
        SELECT c.collection_id, c.entity_id
        FROM contents c
        JOIN nested_collections nc ON c.collection_id = nc.entity_id
        WHERE c.entity_type = 'Collection'
      )

      -- Check if the target collection is present in the recursive traversal results
      SELECT 1
      FROM nested_collections
      WHERE entity_id = $2
      LIMIT 1;
    SQL

    # Execute the raw SQL query
    result = ActiveRecord::Base.connection.exec_query(cte_query, 'contains_collection?', [[nil, id], [nil, target_collection_id]])

    # Check if there's any row in the result
    result.any?
  end
end
