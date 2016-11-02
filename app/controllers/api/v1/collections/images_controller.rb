module Api
  module V1
    module Collections
      class ImagesController < BaseController
        # GET /api/:user_id/collections/:collection_id/images
        def index
          @user = User.friendly.find(params[:user_id])
          @collection = @user.collections.find(params[:collection_id])
          @images = @collection.images.page(params[:page]).per(params[:per])
          render_collection @images, serializer: ImageSerializer
        end

        def sample
          @user = User.friendly.find(params[:user_id])
          @collection = @user.collections.find(params[:collection_id])
          @images = @collection.images.unscope(:order).order('RANDOM()').limit(params[:size] || 5)
          render_array @images, serializer: ImageSerializer
        end
      end
    end
  end
end