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

  validates :title, presence: true
  validate :validate_schema_structure, if: -> { schema.present? }

  belongs_to :user, inverse_of: :collections
  has_many :contents, -> { order position: :asc }, dependent: :destroy, inverse_of: :collection

  has_many :attachments, through: :contents, source: :entity, source_type: 'Attachment'
  has_many :collections, through: :contents, source: :entity, source_type: 'Collection'
  has_many :images, through: :contents, source: :entity, source_type: 'Image'
  has_many :links, through: :contents, source: :entity, source_type: 'Link'
  has_many :texts, through: :contents, source: :entity, source_type: 'Text'

  include HasUrl
  has_url template: -> { { segments: ['xs', slug] } }

  VALID_SCHEMA_TYPES = %w[string number boolean].freeze
  BOOLEAN_VALUES = [true, false].freeze

  before_destroy do
    Content.where(entity_type: 'Collection', entity_id: id).destroy_all
  end

  def schema_fields
    schema&.dig('fields') || {}
  end

  def validate_content_metadata(metadata)
    return true if schema.blank?

    errors = []
    schema_fields.each do |field_name, field_def|
      value = metadata[field_name]

      if field_def['required'] && value.nil?
        errors << "#{field_name} is required"
        next
      end

      next if value.nil?

      case field_def['type']
      when 'string'
        errors << "#{field_name} must be a string" unless value.is_a?(String)
      when 'number'
        errors << "#{field_name} must be a number" unless value.is_a?(Numeric)
      when 'boolean'
        errors << "#{field_name} must be a boolean" unless BOOLEAN_VALUES.include?(value)
      end
    end

    errors
  end

  def to_s
    title
  end

  def published?
    key?
  end

  def contains_collection?(target_collection_id)
    # Recursive CTE to find nested collections
    cte_query = <<-SQL.squish
    WITH RECURSIVE nested_collections(path) AS (
      SELECT ARRAY[collection_id, entity_id]::bigint[]
      FROM contents
      WHERE collection_id = $1::bigint AND entity_type = 'Collection'

      UNION ALL

      SELECT (nc.path || c.entity_id)::bigint[]
      FROM contents c
      JOIN nested_collections nc ON c.collection_id = nc.path[array_upper(nc.path, 1)]
      WHERE c.entity_type = 'Collection' AND NOT (c.entity_id = ANY(nc.path))
    )

    SELECT 1
    FROM nested_collections
    WHERE $2::bigint = ANY(path)
    LIMIT 1;
    SQL

    # Execute the raw SQL query with explicit type casting
    result = ActiveRecord::Base.connection.exec_query(
      cte_query,
      'contains_collection?',
      [
        ActiveRecord::Relation::QueryAttribute.new('id', id, ActiveRecord::Type::BigInteger.new),
        ActiveRecord::Relation::QueryAttribute.new('target_id', target_collection_id, ActiveRecord::Type::BigInteger.new)
      ]
    )

    # Check if there's any row in the result
    result.any?
  end

  # TODO: Validate and further optimize
  def contains_collection_optimized?(target_collection_id)
    # Early return if checking against self
    return false if id == target_collection_id

    # Recursive CTE to find nested collections with depth limit
    cte_query = <<-SQL
      WITH RECURSIVE nested_collections AS (
        -- Base case: direct children
        SELECT entity_id::bigint, 1 as depth
        FROM contents
        WHERE collection_id = $1::bigint
          AND entity_type = 'Collection'

        UNION ALL

        -- Recursive case: children of children
        SELECT c.entity_id::bigint, nc.depth + 1
        FROM contents c
        INNER JOIN nested_collections nc ON c.collection_id = nc.entity_id
        WHERE c.entity_type = 'Collection'
          AND nc.depth < 100  -- Prevent infinite recursion
      )
      SELECT EXISTS (
        SELECT 1
        FROM nested_collections
        WHERE entity_id = $2::bigint
      );
    SQL

    # Execute the raw SQL query with explicit type casting
    result = ActiveRecord::Base.connection.exec_query(
      cte_query,
      'contains_collection_optimized?',
      [
        ActiveRecord::Relation::QueryAttribute.new('id', id, ActiveRecord::Type::BigInteger.new),
        ActiveRecord::Relation::QueryAttribute.new('target_id', target_collection_id, ActiveRecord::Type::BigInteger.new)
      ]
    )

    result.first['exists']
  end

  private

  def validate_schema_structure
    return if valid_schema_structure?

    errors.add(:schema, 'must be a valid schema structure')
  end

  def valid_schema_structure?
    return false unless schema.is_a?(Hash)
    return false unless schema['fields'].is_a?(Hash)

    schema['fields'].all? do |_field_name, field_def|
      field_def.is_a?(Hash) &&
        VALID_SCHEMA_TYPES.include?(field_def['type']) &&
        BOOLEAN_VALUES.include?(field_def['required'])
    end
  end
end
