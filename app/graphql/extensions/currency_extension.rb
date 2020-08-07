# frozen_string_literal: true

module Extensions
  class CurrencyExtension < GraphQL::Schema::FieldExtension
    def apply
      field.argument(:separator, GraphQL::Types::String, required: false, default_value: '.')
      field.argument(:delimiter, GraphQL::Types::String, required: false, default_value: ',')
      field.argument(:precision, GraphQL::Types::Int, required: false, default_value: 2)
      field.argument(:strip_insignificant_zeros, GraphQL::Types::Boolean, required: false, default_value: true)
    end

    def resolve(object:, arguments:, context:)
      value =
        begin
          yield(object, arguments, context)
        rescue StandardError
          object.object.send(field.name.underscore)
        end

      self.class.format_currency(value: value, **arguments)
    end

    class << self
      include ActionView::Helpers::NumberHelper

      def format_currency(value:, **options)
        number_to_currency(value / 100, options.merge(raise: true))
      end
    end
  end
end
