# frozen_string_literal: true

class AddMetadataToContents < ActiveRecord::Migration[6.1]
  def change
    add_column :contents, :metadata, :jsonb, null: false, default: {}
  end
end
