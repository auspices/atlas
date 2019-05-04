# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string(255)      not null
#  username                        :string(255)      not null
#  crypted_password                :string(255)      not null
#  salt                            :string(255)      not null
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string(255)
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  slug                            :string(255)
#

class User < ApplicationRecord
  include ActiveModel::Dirty

  extend FriendlyId
  friendly_id :username

  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true, presence: true, format: { with: /\A[a-z0-9_-]+\z/ }, length: { maximum: 15 }
  validates :password, presence: true, confirmation: true, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, length: { minimum: 3 }, on: :update, unless: ->(user) { user.password.blank? }

  has_many :connections, dependent: :destroy
  has_many :collections, -> { order updated_at: :desc }, dependent: :destroy
  has_many :images, -> { order created_at: :desc }, dependent: :destroy

  def to_s
    username
  end

  def admin?
    id == 1
  end

  # TODO: Aliases `contents` to `images` as we do not have distinct content types yet.
  alias contents images
end
