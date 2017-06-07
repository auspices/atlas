# frozen_string_literal: true

module Collections
  class ImagesController < ApplicationController
    before_action :find_collection

    # POST /users/:user_id/collections/:collection_id/images
    def create
      ActiveRecord::Base.transaction do
        @image = current_user.images.create(image_params)
        @connection = Connector.build(current_user, @collection, @image)
        @connection.save
      end
      if @connection.persisted?
        redirect_to :back, success: 'Image was added'
      else
        redirect_to :back, error: @image.errors.full_messages.join(', ')
      end
    end

    # GET /:user_id/:collection_id/add/:source_url
    def add
      source_url = add_params.values.join('.').gsub(':/', '://').gsub(':///', '://')

      ActiveRecord::Base.transaction do
        @image = current_user.images.create(source_url: source_url)
        @connection = Connector.build(current_user, @collection, @image)
        @connection.save
      end
      if @connection.persisted?
        redirect_to [current_user, @collection], success: 'Image was added'
      else
        redirect_to [current_user, @collection], error: @image.errors.full_messages.join(', ')
      end
    end

    private

    def find_collection
      @collection = current_user.collections.find(params[:collection_id])
    end

    def image_params
      params.require(:image).permit(:source_url)
    end

    def add_params
      params.permit(:source_url, :format)
    end
  end
end
