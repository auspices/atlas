# frozen_string_literal: true

module Types
  class ContentsSortType < BaseEnum
    value 'POSITION_ASC', value: { position: :asc }
    value 'POSITION_DESC', value: { position: :desc }
    value 'CREATED_AT_ASC', value: { created_at: :asc }
    value 'CREATED_AT_DESC', value: { created_at: :desc }
    value 'UPDATED_AT_ASC', value: { updated_at: :asc }
    value 'UPDATED_AT_DESC', value: { updated_at: :desc }
  end
end
