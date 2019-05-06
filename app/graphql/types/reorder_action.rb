# frozen_string_literal: true

module Types
  class ReorderAction < BaseEnum
    value 'INSERT_AT', value: :insert_at
    value 'MOVE_TO_TOP', value: :move_to_top
    value 'MOVE_TO_BOTTOM', value: :move_to_bottom
    value 'MOVE_UP', value: :move_up
    value 'MOVE_DOWN', value: :move_down
  end
end
