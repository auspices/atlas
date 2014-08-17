class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.page(params[:page]).per(params[:per])
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /register
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, success: 'User was added'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, success: 'User was updated'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
