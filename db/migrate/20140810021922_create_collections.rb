# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title
      t.integer :connections_count, default: 0
      t.integer :user_id, null: false

      t.timestamps
      t.index [:user_id]
    end
  end
end
