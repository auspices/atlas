# frozen_string_literal: true

class AddSchemaToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :schema, :jsonb, null: true, default: nil
    add_index :collections, :schema, using: :gin
  end
end
