class AddCombinedIndexToContents < ActiveRecord::Migration[6.1]
  def change
    add_index :contents, [:collection_id, :entity_id, :entity_type]
  end
end
