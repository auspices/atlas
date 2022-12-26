# frozen_string_literal: true

module Types
  class EntityTypes < BaseEnum
    value 'ATTACHMENT', value: Attachment
    value 'COLLECTION', value: Collection
    value 'IMAGE', value: Image
    value 'LINK', value: Link
    value 'TEXT', value: Text
  end
end
