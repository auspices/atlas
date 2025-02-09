# frozen_string_literal: true

# == Schema Information
#
# Table name: attachments
#
#  id                  :bigint           not null, primary key
#  url                 :text
#  file_name           :text
#  file_content_type   :string
#  file_content_length :integer
#  user_id             :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Attachment < ApplicationRecord
  include Uploadable

  has_many :contents, as: :entity, dependent: :destroy
  has_many :collections, through: :contents
  belongs_to :user

  validates :file_name, presence: true
  validates :file_content_type, presence: true
  validates :file_content_length, presence: true

  def to_s
    file_name
  end
end
