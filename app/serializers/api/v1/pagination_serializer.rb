module Api
  module V1
    class PaginationSerializer < BaseSerializer
      attributes :_embedded, :_links, :total_count, :total_pages

      def initialize(object, options = {})
        @current_url = options[:current_url]
        @each = options[:each_serializer]
        @resource_name = options[:resource_name]
        super(object, options)
      end

      def total_count
        self.object.total_count
      end

      def total_pages
        self.object.total_pages
      end

      def _embedded
        ActiveModel::ArraySerializer.new(self.object, each_serializer: @each, root: @resource_name)
      end

      def current_url(options = {})
        @current_url.call options
      end

      def _links
        {
          self: { href: current_url(page: self.object.current_page) },
          first: { href: current_url(page: 1) },
          next: { href: current_url(page: self.object.next_page) },
          prev: { href: current_url(page: self.object.prev_page) },
          last: { href: current_url(page: self.object.total_pages) }
        }
      end
    end
  end
end
