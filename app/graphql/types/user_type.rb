# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    include Shared::Timestamps

    field :id, Int, null: false
    field :username, String, null: false
    field :email, String, null: false
    field :slug, String, null: false

    field :services, [String], null: false
    field :customer, CustomerType, null: false

    field :counts, Types::UserCountsType, null: false

    def counts
      object
    end

    field :content, Types::ContentType, null: false do
      argument :id, ID, required: true
    end

    def content(id:)
      object.contents.find(id)
    end

    field :collection, Types::CollectionType, null: false do
      argument :id, ID, required: true
    end

    def collection(id:)
      object.collections.friendly.find(id)
    end

    field :collections, [Types::CollectionType], null: false do
      argument :page, Int, required: false
      argument :per, Int, required: false
      argument :query, String, required: false
    end

    def collections(page: nil, per: nil, query: nil)
      results = object.collections
      results = results.where('lower(title) like ?', "%#{query.downcase}%") if query.present?
      results.page(page).per(per)
    end

    field :sample, [Types::ContentType], null: false do
      argument :amount, Int, required: false
    end

    def sample(amount: 1)
      object.contents.unscope(:order).order('RANDOM()').limit(amount)
    end

    field :presigned_upload_urls, [String], null: false do
      argument :types, [Types::SupportedUploadType], required: true
    end

    def presigned_upload_urls(types:)
      types.map do |type|
        ext, mime_type = type.values_at(:ext, :mime_type)

        UploadManager.presigned_url(
          mime_type: mime_type,
          user_id: current_user.id,
          filename: "#{UploadManager.token}.#{ext}"
        )
      end
    end
  end
end
