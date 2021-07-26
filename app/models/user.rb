# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  username                        :string           not null
#  crypted_password                :string           not null
#  salt                            :string           not null
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  slug                            :string
#  phone_number                    :string
#  subscriptions                   :jsonb            not null
#  customer_id                     :string
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

  has_many :contents, dependent: :destroy
  has_many :collections, -> { order updated_at: :desc }, dependent: :destroy
  has_many :images, -> { order created_at: :desc }, dependent: :destroy
  has_many :texts, -> { order created_at: :desc }, dependent: :destroy
  has_many :links, -> { order created_at: :desc }, dependent: :destroy
  has_many :attachments, -> { order created_at: :desc }, dependent: :destroy

  def to_s
    username
  end

  def create_customer!
    return customer if customer?

    Stripe::Customer.create(
      email: email,
      metadata: { id: id }
    ).tap do |stripe_customer|
      update!(customer_id: stripe_customer.id)
    end
  end

  def customer
    return nil unless customer?

    @customer ||= Stripe::Customer.retrieve(customer_id)
  end

  def customer?
    customer_id?
  end

  def subscribe_to!(key)
    subscriptions << Product.find(key)
    subscriptions.uniq!
    save!
  end

  def subscribed_to?(*keys)
    products = keys.map { |key| Product.find(key.to_sym) }
    products.all? { |product| subscriptions.include?(product) }
  rescue KeyError
    false
  end

  def unsubscribe_from!(key)
    product = Product.find(key)
    subscriptions.reject { |subscribed_product| subscribed_product == product }
  end
end
