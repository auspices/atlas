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

    field :contents, [Types::ContentType], null: false do
      argument :page, Int, required: false
      argument :per, Int, required: false
      argument :metadata, GraphQL::Types::JSON, required: false
      argument :sort_by, Types::ContentsSortType, required: false
    end

    def contents(page: nil, per: nil, metadata: nil, sort_by: nil)
      results = object.contents
      results = results.unscope(:order).order(sort_by) if sort_by.present?
      results = results.where('metadata @> ?', metadata.to_json) if metadata.present?
      results.page(page).per(per)
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
      argument :uploads, [Types::UploadInput], required: true
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
