# frozen_string_literal: true

class AddUserIdToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :user_id, :integer
    add_index :images, :user_id
  end
end
