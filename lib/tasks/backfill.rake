# frozen_string_literal: true

namespace :backfill do
  task populate_image_file_metadata: [:environment] do
    Image.where(file_name: nil).find_each do |image|
      puts "Backfilling image #{image.id}"

      image.file_name = File.basename(image.source_url || image.url)

      io = OpenURI.open_uri(image.uri)
      image.file_content_type = FastImage.type(io)

      io.rewind
      image.file_content_length = io.size

      image.save!
    rescue StandardError
      puts "Failed to backfill image #{image.id}"
    end
  end
end
