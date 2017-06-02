# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      # GET /api/user/1
      def show
        @user = User.friendly.find(params[:id])
        render_object @user, serializer: UserSerializer
      end
    end
  end
end
