module Api
  module V1
    class CollectionSerializer < BaseSerializer
      attributes :id, :slug, :title, :connections_count, :created_at, :updated_at, :user_id, :_links

      def _links
        {
          self: { href: api_user_collection_url(self.user_id, self.id) },
          images: {
            href: CGI.unescape(api_user_collection_images_url(self.user_id, self.id, page: '{page}', per: '{per}')),
            templated: true
          },
          user: { href: api_user_url(self.user_id) }
        }
      end
    end
  end
end
