# frozen_string_literal: true

class AddPositionToConnection < ActiveRecord::Migration[6.1]
  def change
    add_column :connections, :position, :integer

    Collection.find_each do |collection|
      collection.connections.unscope(:order).order(created_at: :desc).each.with_index do |connection, index|
        connection.update_column(:position, index)
      end
    end
  end
end
