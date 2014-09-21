module Api
  module V1
    class UsersController < ActionController::Base
      # GET /api/user/1
      def show
        # @user = User.friendly.find(params[:id])
        # render json: @user
      end
    end
  end
end
