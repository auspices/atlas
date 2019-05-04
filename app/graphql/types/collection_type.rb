# frozen_string_literal: true

module Types
  class CollectionType < Types::BaseObject
    include Shared::Timestamps

    field :id, Int, null: false
    field :slug, String, null: false
    field :title, String, null: false

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
  end
end
