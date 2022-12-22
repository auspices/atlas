# frozen_string_literal: true

namespace :backfill do
  task populate_image_file_metadata: [:environment] do
    Image.where(file_name: nil).limit(500).find_each do |image|
      puts "Backfilling image #{image.id}"

      io = OpenURI.open_uri(image.uri)
      type = FastImage.type(io)
      io.rewind

      file_name = File.basename(image.source_url || image.url)
      file_content_type = "image/#{type}"
      file_content_length = io.size

      image.update_columns(
        file_name: file_name,
        file_content_type: file_content_type,
        file_content_length: file_content_length
      )
    rescue StandardError
      puts "Failed to backfill image #{image.id}"
    end
  end
end

