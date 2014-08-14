# == Schema Information
#
# Table name: collections
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  connections_count :integer          default(0)
#  user_id           :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Collection < ActiveRecord::Base
  validates :title, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :connections, -> { order created_at: :desc }, dependent: :destroy
  has_many :images, through: :connections

  def display_size
    connections.size == 0 ? 'Empty' : connections.size
  end
end
