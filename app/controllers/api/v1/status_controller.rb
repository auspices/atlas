# frozen_string_literal: true

module Api
  module V1
    class StatusController < BaseController
      # GET /api/status
      def index
        render json: { up: true }
      end
    end
  end
end
