# frozen_string_literal: true

class AddCustomerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :customer_id, :string
    add_index :users, :customer_id, unique: true
  end
end
