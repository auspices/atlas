class ImagesController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]
  before_action :set_user, only: [:index, :show]

  # GET /users/:user_id/images
  def index
    @images = @user.images.order(created_at: :desc).page(params[:page])
  end

  # GET /users/:user_id/images/:id
  def show
    @image = @user.images.find(params[:id])
  end

  # GET /images/new
  def new
    @image = current_user.images.build
  end

  # POST /images
  def create
    @image = current_user.images.build(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to [current_user, @image], notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  def update
    @image = current_user.images.find(params[:id])
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to [current_user, @image], notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = current_user.images.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.html { redirect_to :root, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def image_params
    params.require(:image).permit(:source_url)
  end
end
