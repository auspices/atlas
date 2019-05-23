# frozen_string_literal: true

class AddMetadataToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :metadata, :jsonb, null: false, default: {}
  end
end
