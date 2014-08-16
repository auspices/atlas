class SessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  # GET /login
  def new
    @user = User.new
  end

  # POST /sessions
  def create
    if @user = login(params[:username], params[:password])
      redirect_back_or_to :root, notice: 'Hello'
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  # GET /logout
  def destroy
    logout
    redirect_to :root, notice: 'Goodbye'
  end
end
