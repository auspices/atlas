module Api
  module V1
    class StatusController < ActionController::Base
      # GET /api/status
      def index
        render json: { up: true }
      end
    end
  end
end
