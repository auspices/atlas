class AuthController < ApplicationController
  before_action :authenticate

  def login
    redirect_to :root
  end
end
