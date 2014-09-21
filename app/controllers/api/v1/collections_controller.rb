module Api
  module V1
    class CollectionsController < BaseController
      # GET /api/:user_id/collections
      def index
        @user = User.friendly.find(params[:user_id])
        @collections = @user.collections.page(params[:page]).per(params[:per])
        render_collection @collections, serializer: CollectionSerializer
      end

      # GET /api/:user_id/collections/:id
      def show
        @user = User.friendly.find(params[:user_id])
        @collection = @user.collections.find(params[:id])
        render_object @collection, serializer: CollectionSerializer
      end
    end
  end
end
