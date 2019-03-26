# frozen_string_literal: true

class AtlasSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
  # GraphQL::Batch setup:
  use GraphQL::Batch
end
