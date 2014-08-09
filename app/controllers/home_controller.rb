class HomeController < ApplicationController
  def index
    @images = current_user.images.order(created_at: :desc).page(params[:page])
    render template: 'images/index'
  end
end
