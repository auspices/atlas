# frozen_string_literal: true

class AddSubscriptionsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscriptions, :jsonb, null: false, default: []
  end
end
