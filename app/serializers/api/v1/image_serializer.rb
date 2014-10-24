module Api
  module V1
    class ImageSerializer < BaseSerializer
      attributes :id, :url, :width, :height, :source_url, :created_at, :updated_at, :user_id, :_links

      def _links
        {
          self: { href: api_user_image_url(self.user_id, self.id) },
          images: { href: api_user_images_url(self.user_id) },
          user: { href: api_user_url(self.user_id) }
        }
      end
    end
  end
end
