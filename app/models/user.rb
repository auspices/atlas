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
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates_presence_of :password, on: :create
  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :username, presence: true, format: { with: /\A[a-z0-9_-]+\z/ }, length: { maximum: 15 }

  has_many :images, -> { order created_at: :desc }, dependent: :destroy

  def admin?
    username == 'damon'
  end
end
