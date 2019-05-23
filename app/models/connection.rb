# frozen_string_literal: true

# == Schema Information
#
# Table name: connections
#
#  id            :integer          not null, primary key
#  collection_id :integer          not null
#  image_id      :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer
#

class Connection < ApplicationRecord
  validates :collection_id, presence: true
  validates :image_id, presence: true
  validates :user_id, presence: true

  belongs_to :user
  belongs_to :collection, counter_cache: :connections_count, touch: true
  belongs_to :image

  acts_as_list scope: :collection, top_of_list: 0, add_new_at: :top

  # TODO: Aliases `content` to `image` as we do not have distinct content types yet.
  alias content image
end
