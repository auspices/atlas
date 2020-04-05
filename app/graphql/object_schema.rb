# frozen_string_literal: true

class ObjectSchema < GraphQL::Schema
  query Types::ObjectQueryType
  use BatchLoader::GraphQL
end

GraphQL::Errors.configure(ObjectSchema) do
  rescue_from ActiveRecord::RecordNotFound do |exception|
    Errors::NotFoundError.new(exception.message)
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Errors::InvalidRecordError.new(exception.record.errors.full_messages.join('; '))
  end
end
