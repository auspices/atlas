# frozen_string_literal: true

class ErrorsController < ActionController::Base
  protect_from_forgery with: :null_session

  def not_found
    render json: { status: 404, code: 'NOT_FOUND' }, status: 404
  end
end
