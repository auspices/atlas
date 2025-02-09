# frozen_string_literal: true

class RemoveDefaultCollectionsKeyValue < ActiveRecord::Migration[6.1]
  def change
    change_column_default :collections, :key, from: 'uuid_generate_v4()', to: nil
    change_column_null :collections, :key, true
    add_index :collections, :key, unique: true
  end
end
