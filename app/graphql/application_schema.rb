# frozen_string_literal: true

class ApplicationSchema < GraphQL::Schema
  use(GraphQL::Tracing::NewRelicTracing, set_transaction_name: true) if Rails.env.production?

  mutation Types::MutationType
  query Types::QueryType
  use BatchLoader::GraphQL

  # Prevent overly complex queries
  max_complexity 300
  # Prevent deeply nested queries
  max_depth 15

  rescue_from ActiveRecord::RecordNotFound do |exception|
    Errors::NotFoundError.new(exception.message)
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Errors::InvalidRecordError.new(exception.record.errors.full_messages.join('; '))
  end
end
