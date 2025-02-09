# frozen_string_literal: true

class AddUniqueUrlIndexToImages < ActiveRecord::Migration[6.1]
  def change
    add_index :images, :url, unique: true
  end
end
