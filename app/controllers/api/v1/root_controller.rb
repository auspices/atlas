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
              templated: true,
              images: {
                href: CGI.unescape(api_user_images_url('{user_id}')),
                templated: true
              },
              image: {
                href: CGI.unescape(api_user_image_url('{user_id}', '{id}')),
                templated: true
              },
              collections: {
                href: CGI.unescape(api_user_collections_url('{user_id}')),
                templated: true
              },
              collection: {
                href: CGI.unescape(api_user_collection_url('{user_id}', '{collection_id}')),
                templated: true,
                images: {
                  href: CGI.unescape(api_user_collection_images_url('{user_id}', '{collection_id}')),
                  templated: true
                }
              }
            }
          }
        }
      end
    end
  end
end
