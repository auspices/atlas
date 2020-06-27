# frozen_string_literal: true

class AddCustomerIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :customer_id, :string
    add_index :users, :customer_id, unique: true
  end
end
