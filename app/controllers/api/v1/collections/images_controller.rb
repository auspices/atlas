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
      end
    end
  end
end
