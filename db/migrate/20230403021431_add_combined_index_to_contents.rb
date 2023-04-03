# frozen_string_literal: true

class AddCombinedIndexToContents < ActiveRecord::Migration[6.1]
  def change
    add_index :contents, %i[collection_id entity_id entity_type]
  end
end
