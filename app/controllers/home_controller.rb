class HomeController < ApplicationController
  def index
    @images = current_user.images.page(params[:page])
    render template: 'images/index'
  end
end
