# frozen_string_literal: true

module Types
  class SupportedMimeTypes < BaseEnum
    value 'JPEG', value: 'jpg'
    value 'PNG', value: 'png'
    value 'GIF', value: 'gif'
  end
end
