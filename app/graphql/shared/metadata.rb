# frozen_string_literal: true

module Shared
  module Metadata
    def self.included(child_class)
      child_class.field :metadata, Types::RawJson, null: false

      child_class.field :value, String, null: true, extras: [:irep_node] do
        argument :key, String, required: false
      end
    end

    def value(irep_node:, key: nil)
      object.metadata[key || irep_node.name]
    end
  end
end
