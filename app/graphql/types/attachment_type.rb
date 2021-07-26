# frozen_string_literal: true

module Types
  class AttachmentType < Types::BaseObject
    include Shared::Timestamps
    include Shared::ToString
    include ActionView::Helpers::NumberHelper

    field :id, Int, null: false
    field :url, String, null: false, method: :static
    field :name, String, null: false, method: :to_s
    field :content_type, String, null: false, method: :file_content_type

    field :file_size, String, null: true do
      argument :precision, Integer, required: false, default_value: 3
    end

    def file_size(precision: nil)
      number_to_human_size(object.file_content_length, precision: precision)
    end
  end
end
