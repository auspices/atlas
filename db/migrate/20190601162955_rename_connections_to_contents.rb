# frozen_string_literal: true

class RenameConnectionsToContents < ActiveRecord::Migration[5.2]
  def change
    remove_index :connections, :collection_id
    remove_index :connections, :image_id
    remove_index :connections, :user_id

    rename_table :connections, :contents
    rename_column :collections, :connections_count, :contents_count

    add_index :contents, :collection_id
    add_index :contents, :image_id
    add_index :contents, :user_id
  end
end
