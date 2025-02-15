# frozen_string_literal: true

# == Schema Information
#
# Table name: texts
#
#  id         :bigint           not null, primary key
#  body       :text
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Text < ApplicationRecord
  include StringHelper

  has_many :contents, as: :entity, dependent: :destroy
  has_many :collections, through: :contents
  belongs_to :user

  validates :body, presence: true

  def to_s
    body
  end
end
