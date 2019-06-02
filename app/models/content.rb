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
#

class Content < ApplicationRecord
  validates :collection, :entity, :user, presence: true

  belongs_to :user
  belongs_to :collection, counter_cache: :contents_count, touch: true
  belongs_to :entity, polymorphic: true

  acts_as_list scope: :collection, top_of_list: 0, add_new_at: :top
end
