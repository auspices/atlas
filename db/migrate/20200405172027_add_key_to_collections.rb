# frozen_string_literal: true

class AddKeyToCollections < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'
    add_column :collections, :key, :uuid, unique: true, null: false, default: 'uuid_generate_v4()'
  end
end
