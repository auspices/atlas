class HomeController < ApplicationController
  def index
    redirect_to vanity_user_collections_path(current_user)
  end
end
