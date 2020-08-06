# frozen_string_literal: true

module Extensions
  class DateExtension < GraphQL::Schema::FieldExtension
    def apply
      field.argument(:relative, GraphQL::Types::Boolean, required: false, default_value: nil)
      field.argument(:format, GraphQL::Types::String, required: false, default_value: nil)
    end

    def resolve(object:, arguments:, context:)
      value = begin
        yield(object, arguments, context)
      rescue StandardError
        object.object.send(field.name.underscore)
      end
      self.class.format_date(value: value, relative: arguments[:relative], format: arguments[:format])
    end

    class << self
      include ActionView::Helpers::DateHelper

      def format_date(value:, relative: nil, format: nil)
        if relative
          qualifier = value.future? ? 'from now' : 'ago'
          return "#{time_ago_in_words(value)} #{qualifier}"
        end

        return value.strftime(format) if format

        value
      end
    end
  end
end
