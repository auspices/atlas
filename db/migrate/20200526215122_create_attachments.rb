# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.text :url
      t.text :file_name
      t.string :file_content_type
      t.integer :file_content_length
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
