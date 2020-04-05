# frozen_string_literal: true

class ApplicationSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType
  use BatchLoader::GraphQL
end

GraphQL::Errors.configure(ApplicationSchema) do
  rescue_from ActiveRecord::RecordNotFound do |exception|
    Errors::NotFoundError.new(exception.message)
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Errors::InvalidRecordError.new(exception.record.errors.full_messages.join('; '))
  end
end
