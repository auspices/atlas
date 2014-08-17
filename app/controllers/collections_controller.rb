class CollectionsController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]

  # GET /:user_id
  def index
    @user = User.find(params[:user_id])
    @collections = @user.collections.page(params[:page]).per(params[:per])
  end

  # GET /:user_id/:id
  def show
    @user = User.find(params[:user_id])
    @collection = @user.collections.find(params[:id])
    @images = @collection.images.page(params[:page]).per(params[:per])
    render 'images/index'
  end

  # POST /:user_id/collections
  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      redirect_to :back, success: 'Collection was added'
    else
      redirect_to :back, error: @collection.errors.full_messages.join(', ')
    end
  end

  # DELETE /:user_id/collections/1
  def destroy
    @collection = current_user.collections.find(params[:id])
    @collection.destroy
    redirect_to :back, notice: 'Collection was deleted'
  end

  private

  def collection_params
    params.require(:collection).permit(:title)
  end
end
