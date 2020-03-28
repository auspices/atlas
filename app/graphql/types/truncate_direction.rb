# frozen_string_literal: true

module Types
  class TruncateDirection < BaseEnum
    value 'HEAD', value: :head
    value 'TAIL', value: :tail
    value 'CENTER', value: :center
  end
end
