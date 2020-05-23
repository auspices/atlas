# frozen_string_literal: true

class AddSubscriptionsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subscriptions, :jsonb, null: false, default: []
  end
end
