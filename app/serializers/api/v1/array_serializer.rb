# frozen_string_literal: true

module Api
  module V1
    class ArraySerializer < BaseSerializer
      attributes :_embedded, :_links, :total_count

      def initialize(object, options = {})
        @current_url = options[:current_url]
        @each = options[:each_serializer]
        @resource_name = options[:resource_name]
        super(object, options)
      end

      def total_count
        object.size
      end

      def _embedded
        ActiveModel::ArraySerializer.new(object, each_serializer: @each, root: @resource_name)
      end

      def current_url(options = {})
        @current_url.call options
      end

      def _links
        {
          self: { href: current_url }
        }
      end
    end
  end
end
