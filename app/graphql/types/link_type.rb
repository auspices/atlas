# frozen_string_literal: true

module Types
  class LinkType < Types::BaseObject
    include Shared::Timestamps
    include Shared::ToString

    field :id, Int, null: false
    field :name, String, null: false, method: :to_s
    field :url, String, null: false
  end
end
