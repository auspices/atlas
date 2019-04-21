# frozen_string_literal: true

module Errors
  class BaseError < GraphQL::ExecutionError
    def to_h
      super.merge(
        'extensions' => extensions.reverse_merge('code' => self.class::CODE)
      )
    end
  end
end
