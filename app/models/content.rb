# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id            :integer          not null, primary key
#  collection_id :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer
#  entity_type   :string
#  entity_id     :bigint
#  metadata      :jsonb            not null
#

class Content < ApplicationRecord
  validate :validate_metadata_against_schema, if: -> { collection&.schema.present? }

  belongs_to :user
  belongs_to :collection, counter_cache: :contents_count, touch: true
  belongs_to :entity, polymorphic: true

  acts_as_list scope: :collection, top_of_list: 0, add_new_at: :top

  include HasUrl
  has_url template: -> { { segments: ['x', id] } }

  def to_sms
    "#{entity.to_s.strip}\n#{to_url}"
  end

  private

  def validate_metadata_against_schema
    validation_errors = collection.validate_content_metadata(metadata)
    validation_errors.each { |error| errors.add(:metadata, error) } if validation_errors.any?
  end
end
