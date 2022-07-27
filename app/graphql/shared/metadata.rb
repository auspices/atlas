# frozen_string_literal: true

module Shared
  module Metadata
    def self.included(child_class)
      child_class.field :metadata, GraphQL::Types::JSON, null: false

      child_class.field :value, String, null: true, extras: [:ast_node] do
        argument :key, String, required: false
      end
    end

    def value(ast_node:, key: nil)
      object.metadata[key || ast_node.name]
    end
  end
end
