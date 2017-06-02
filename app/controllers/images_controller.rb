# frozen_string_literal: true

class ImagesController < ApplicationController
  skip_before_filter :require_login, only: %i[index show]

  # GET /:user_id/images
  def index
    @user = User.friendly.find(params[:user_id])
    @images = @user.images.page(params[:page]).per(params[:per])
  end

  # GET /:user_id/images/:id
  def show
    @user = User.friendly.find(params[:user_id])
    @image = @user.images.find(params[:id])
  end

  # POST /:user_id/images
  def create
    @image = current_user.images.build(image_params)
    if @image.save
      redirect_to [current_user, @image], success: 'Image was added'
    else
      redirect_to :back, error: @image.errors.full_messages.join(', ')
    end
  end

  # DELETE /:user_id/images/1
  def destroy
    @image = current_user.images.find(params[:id])
    @image.destroy
    redirect_to :back, notice: 'Image was deleted'
  end

  private

  def image_params
    params.require(:image).permit(:source_url)
  end
end
