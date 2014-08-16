class ImagesController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]

  # GET /:user_id/images
  def index
    @user = User.find(params[:user_id])
    @images = @user.images.page(params[:page])
  end

  # GET /:user_id/images/:id
  def show
    @user = User.find(params[:user_id])
    @image = @user.images.find(params[:id])
  end

  # POST /:user_id/images
  def create
    @image = current_user.images.build(image_params)
    if @image.save
      redirect_to [current_user, @image], notice: 'Image was successfully created.'
    else
      redirect_to :back
    end
  end

  # DELETE /:user_id/images/1
  def destroy
    @image = current_user.images.find(params[:id])
    @image.destroy
    redirect_to :root, notice: 'Image was successfully destroyed.'
  end

  private

  def image_params
    params.require(:image).permit(:source_url)
  end
end
