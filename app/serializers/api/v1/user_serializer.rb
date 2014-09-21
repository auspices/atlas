module Api
  module V1
    class UserSerializer < BaseSerializer
      attributes :id, :slug, :username, :created_at, :updated_at, :_links

      def _links
        {
          self: { href: api_user_url(self.slug) },
          images: { href: api_user_images_url(self.slug) },
          collections: { href: api_user_collections_url(self.slug) }
        }
      end
    end
  end
end
