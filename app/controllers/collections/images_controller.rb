module Collections
  class ImagesController < ApplicationController
    skip_before_filter :require_login, only: :index

    # GET /users/:user_id/collections/:collection_id/images
    def index
      @user = User.find(params[:user_id])
      @collection = @user.collections.find(params[:collection_id])
      @images = @collection.images.page(params[:page])
      render 'images/index'
    end

    # POST /users/:user_id/collections/:collection_id/images
    def create
      ActiveRecord::Base.transaction do
        @collection = current_user.collections.find(params[:collection_id])
        @image = current_user.images.create!(image_params)
        @connection = Connector.new(current_user, @collection, @image).build.save
      end
      if @connection.persisted?
        redirect_to :back, notice: 'Image was successfully created.'
      else
        redirect_to :back
      end
    end

    private

    def image_params
      params.require(:image).permit(:source_url)
    end
  end
end
