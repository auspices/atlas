module Api
  module V1
    class UserSerializer < BaseSerializer
      attributes :id, :slug, :username, :created_at, :updated_at, :_links

      def _links
        {
          self: { href: api_user_url(slug) },
          images: { href: api_user_images_url(slug) },
          image: {
            href: CGI.unescape(api_user_image_url(slug, '{id}')),
            templated: true
          },
          collections: { href: api_user_collections_url(slug) },
          collection: {
            href: CGI.unescape(api_user_collection_url(slug, '{id}')),
            templated: true
          }
        }
      end
    end
  end
end
