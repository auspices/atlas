# frozen_string_literal: true

class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.integer :collection_id, null: false
      t.integer :image_id, null: false
      t.integer :user_id, null: false

      t.timestamps
      t.index [:collection_id]
      t.index [:image_id]
      t.index [:user_id]
    end
  end
end
