class AddFileMetadataToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :file_name, :text
    add_column :images, :file_content_type, :string
    add_column :images, :file_content_length, :integer
  end
end
