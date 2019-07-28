# frozen_string_literal: true

module Types
  class SupportedUploadType < BaseEnum
    value 'JPEG', value: { ext: 'jpg', mime_type: 'image/jpeg' }
    value 'PNG', value: { ext: 'png', mime_type: 'image/png' }
    value 'GIF', value: { ext: 'gif', mime_type: 'image/gif' }
  end
end
