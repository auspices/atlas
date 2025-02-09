# frozen_string_literal: true

class CreateTexts < ActiveRecord::Migration[6.1]
  def change
    create_table :texts do |t|
      t.text :body
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
