# frozen_string_literal: true

class HomeController < ApplicationController
  # GET /
  def index
    redirect_to user_collections_path(current_user)
  end
end
