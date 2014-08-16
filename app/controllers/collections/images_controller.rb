module Collections
  class ImagesController < ApplicationController
    # POST /users/:user_id/collections/:collection_id/images
    def create
      ActiveRecord::Base.transaction do
        @collection = current_user.collections.find(params[:collection_id])
        @image = current_user.images.create!(image_params)
        @connection = Connector.build(current_user, @collection, @image)
        @connection.save
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
