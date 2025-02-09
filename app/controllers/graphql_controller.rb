# frozen_string_literal: true

class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token

  def execute
    variables = ensure_hash(params[:variables])
    result = ApplicationSchema.execute(params[:query],
                                       variables:,
                                       context: { current_user: },
                                       operation_name: params[:operationName])
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def current_user
    @current_user ||= if (auth_header = request.headers['Authorization']).present?
      begin
        payload = JsonWebToken.decode(auth_header.split.last)
        payload && User.find_by(id: payload[:id])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound => _e
        User.new
      end
    else
      User.new
    end
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: {
      error: {
        message: err.message, backtrace: err.backtrace
      },
      data: {}
    }, status: 500
  end
end
