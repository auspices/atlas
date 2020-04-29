# frozen_string_literal: true

module Shared
  module Href
    def self.included(child_class)
      child_class.field :href, GraphQL::Types::String, null: false do
        argument :absolute, GraphQL::Types::Boolean, required: false
      end
    end

    def href(absolute: false)
      object.to_url(absolute: absolute)
    end
  end
end
