module Api
  module V1
    class BaseController < ActionController::Base
      private

      def render_object(object, options = {})
        render json: object, serializer: options[:serializer]
      end

      def render_collection(collection, options = {})
        render json: collection,
          serializer: PaginationSerializer,
          each_serializer: options[:serializer],
          current_url: ->(overrides = {}) { _current_url(overrides) }
      end

      def _current_url(overrides)
        params.select do |k, _|
          [:per].include? k.to_sym
        end.symbolize_keys.tap do |plucked|
          overrides.reverse_merge! plucked
        end
        CGI.unescape(url_for(params: overrides))
      end
    end
  end
end
