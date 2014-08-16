class CollectionsController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]

  # GET /:user_id
  def index
    @user = User.find(params[:user_id])
    @collections = @user.collections.page(params[:page])
  end

  # GET /:user_id/:id
  def show
    @user = User.find(params[:user_id])
    @collection = @user.collections.find(params[:id])
    @images = @collection.images.page(params[:page])
    render 'images/index'
  end

  # POST /:user_id/collections
  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      redirect_to :back, notice: 'Collection was successfully created.'
    else
      redirect_to :back
    end
  end

  # DELETE /:user_id/collections/1
  def destroy
    @collection = current_user.collections.find(params[:id])
    @collection.destroy
    redirect_to :back, notice: 'Collection was successfully destroyed.'
  end

  private

  def collection_params
    params.require(:collection).permit(:title)
  end
end
