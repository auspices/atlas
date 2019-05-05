# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { status: 200, code: 'OK' }
  end
end
