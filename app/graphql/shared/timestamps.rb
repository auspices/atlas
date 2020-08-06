# frozen_string_literal: true

module Shared
  module Timestamps
    def self.timestamp(child_class, name)
      child_class.instance_eval do
        field name, type: String, null: false, extensions: [Extensions::DateExtension]
      end
    end

    def self.included(child_class)
      timestamp(child_class, :updated_at)
      timestamp(child_class, :created_at)
    end
  end
end
