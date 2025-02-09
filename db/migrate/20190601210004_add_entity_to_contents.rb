# frozen_string_literal: true

require_relative '../migration_helpers'

class AddEntityToContents < ActiveRecord::Migration[6.1]
  def change
    add_reference :contents, :entity, polymorphic: true, index: true

    reversible do |dir|
      dir.up do
        ignore_timestamps do
          Content.update_all("entity_id = image_id, entity_type = 'Image'")
        end

        remove_column :contents, :image_id
      end

      dir.down do
        add_column :contents, :image_id, :integer

        ignore_timestamps do
          Content.update_all('image_id = entity_id')
        end
      end
    end
  end
end
