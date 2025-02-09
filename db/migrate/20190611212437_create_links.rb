# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.text :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
