# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    include Shared::Timestamps

    field :id, Int, null: false

    field :content, Types::ContentType, null: false do
      argument :id, ID, required: true
    end

    field :contents, [Types::ContentType], null: false do
      argument :metadata, GraphQL::Types::JSON, required: false
      argument :page, Int, required: false
      argument :per, Int, required: false
      argument :sort_by, Types::ContentsSortType, required: false
    end

    field :collection, Types::CollectionType, null: false do
      argument :id, ID, required: true
    end

    field :collections, [Types::CollectionType], null: false do
      argument :page, Int, required: false
      argument :per, Int, required: false
      argument :query, String, required: false
    end

    field :sample, [Types::ContentType], null: false do
      argument :amount, Int, required: false
    end

    field :presigned_upload_urls, [String], null: false do
      argument :uploads, [Types::UploadInput], required: true
    end

    field :email, String, null: false
    field :slug, String, null: false
    field :username, String, null: false

    field :customer, CustomerType, null: false
    field :services, [String], null: false

    field :counts, Types::UserCountsType, null: false

    def counts
      object
    end

    def content(id:)
      object.contents.find(id)
    end

    def contents(page: nil, per: nil, metadata: nil, sort_by: nil)
      results = object.contents
      results = results.unscope(:order).order(sort_by) if sort_by.present?
      results = results.where('metadata @> ?', metadata.to_json) if metadata.present?
      results.page(page).per(per)
    end

    def collection(id:)
      object.collections.friendly.find(id)
    end

    def collections(page: nil, per: nil, query: nil)
      results = object.collections
      results = results.where('lower(title) like ?', "%#{query.downcase}%") if query.present?
      results.page(page).per(per)
    end

    def sample(amount: 1)
      object.contents.unscope(:order).order('RANDOM()').limit(amount)
    end

    def presigned_upload_urls(uploads:)
      uploads.map do |upload|
        # Accept the given file extension
        extension = File.extname(upload[:name])
        # Otherwise try to invert it from the MIME type
        extension = Rack::Mime::MIME_TYPES.invert[upload[:type]] if extension.blank?
        # Otherwise fallback to bin
        extension = '.bin' if extension.blank?

        UploadManager.presigned_url(
          mime_type: upload[:type],
          user_id: object.id,
          filename: "#{UploadManager.token}#{extension}"
        )
      end
    end
  end
end
