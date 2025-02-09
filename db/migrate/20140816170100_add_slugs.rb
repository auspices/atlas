# frozen_string_literal: true

class AddSlugs < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true

    add_column :collections, :slug, :string
    # Will be scoped under users so, not unique
    add_index :collections, :slug
  end
end
