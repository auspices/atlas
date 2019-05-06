# frozen_string_literal: true

class AddPositionToConnection < ActiveRecord::Migration[5.2]
  def change
    add_column :connections, :position, :integer

    Collection.find_each do |collection|
      collection.connections.order(:updated_at).each.with_index do |connection, index|
        connection.update_column(:position, index)
      end
    end
  end
end
