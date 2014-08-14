class CollectionsController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]

  # GET /users/:user_id/collections
  def index
    @user = User.find(params[:user_id])
    @collections = @user.collections.page(params[:page])
  end

  # GET /users/:user_id/collections/:id
  def show
    @user = User.find(params[:user_id])
    @collection = @user.collections.find(params[:id])
  end

  # POST /users/:user_id/collections
  def create
    @collection = current_user.collections.build(collection_params)
    respond_to do |format|
      if @collection.save
        format.html { redirect_to [current_user, @collection], notice: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:user_id/collections/1
  def destroy
    @collection = current_user.collections.find(params[:id])
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to :root, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:title)
  end
end
