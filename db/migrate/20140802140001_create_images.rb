# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.text :url
      t.text :source_url

      t.timestamps
    end
  end
end
