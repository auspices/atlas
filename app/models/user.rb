class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :password, on: :create
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  has_many :images

  def is_admin?
    username == 'damon'
  end
end
