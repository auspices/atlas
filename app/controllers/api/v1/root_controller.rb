module Api
  module V1
    class RootController < BaseController
      def index
        render json: {
          _links: {
            self: { href: api_root_url },
            status: { href: api_status_index_url },
            user: {
              href: CGI.unescape(api_user_url('{id}')),
              templated: true
            }
          }
        }
      end
    end
  end
end
