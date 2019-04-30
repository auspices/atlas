# frozen_string_literal: true

module Types
  class CollectionType < Types::BaseObject
    field :id, Int, null: false
    field :slug, String, null: false
    field :title, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false

    field :counts, Types::CollectionCountsType, null: false

    def counts
      object
    end

    field :contents, [Types::ContentType], null: true do
      argument :page, Int, required: false
      argument :per, Int, required: false
    end

    def contents(page: nil, per: nil)
      object.contents.page(page).per(per)
    end

    field :sample, [Types::ContentType], null: true do
      argument :amount, Int, required: false
    end

    def sample(amount: 1)
      object.contents.unscope(:order).order('RANDOM()').limit(amount)
    end

    field :presigned_upload_url, String, null: false do
      argument :type, Types::SupportedUploadTypes, required: true
    end

    def presigned_upload_url(type:)
      ext, mime_type = type.values_at(:ext, :mime_type)

      UploadManager.presigned_url(
        mime_type: mime_type,
        user_id: current_user.id,
        filename: "#{UploadManager.token}.#{ext}"
      )
    end
  end
end
