# frozen_string_literal: true

module Shared
  module ToString
    include StringHelper

    def self.included(child_class)
      child_class.field :to_string, GraphQL::Types::String, null: false do
        argument :length, GraphQL::Types::Int, required: false
        argument :from, Types::TruncateDirection, required: false
      end
    end

    def to_string(length: nil, from: :tail)
      string = object.to_s
      return string unless length

      truncate(string, length: length, from: from)
    end
  end
end
