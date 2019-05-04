# frozen_string_literal: true

module Shared
  module Timestamps
    include ActionView::Helpers::DateHelper

    def self.timestamp(child_class, name)
      child_class.instance_eval do
        field(name, String, null: false) do
          argument :relative, GraphQL::Types::Boolean, required: false, default_value: nil
          argument :format, GraphQL::Types::String, required: false, default_value: nil
        end
      end
    end

    def self.included(child_class)
      timestamp(child_class, :updated_at)
      timestamp(child_class, :created_at)
    end

    def timestamp(field_name, relative:, format:)
      if (value = object.send(field_name)).present?
        if relative
          qualifier = value.future? ? 'from now' : 'ago'
          return "#{time_ago_in_words(value)} #{qualifier}"
        end

        return value.strftime(format) if format
      end

      value
    end

    def updated_at(**args)
      timestamp(:updated_at, **args)
    end

    def created_at(**args)
      timestamp(:created_at, **args)
    end
  end
end
