# frozen_string_literal: true

module Api
  module V1
    class ImagesController < BaseController
      # GET /api/:user_id/images
      def index
        @user = User.friendly.find(params[:user_id])
        @images = @user.images.page(params[:page]).per(params[:per])
        render_collection @images, serializer: ImageSerializer
      end

      # GET /api/:user_id/images/:id
      def show
        @user = User.friendly.find(params[:user_id])
        @image = @user.images.find(params[:id])
        render_object @image, serializer: ImageSerializer
      end

      # GET /api/:user_id/images/sample
      def sample
        @user = User.friendly.find(params[:user_id])
        @images = @user.images.unscope(:order).order('RANDOM()').limit(params[:size] || 5)
        render_array @images, serializer: ImageSerializer
      end
    end
  end
end
