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
          current_url: ->(params = {}) { url_for(params: params) }
      end
    end
  end
end
