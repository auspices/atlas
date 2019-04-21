# frozen_string_literal: true

module Errors
  class InvalidRecordError < Errors::BaseError
    CODE = 'UNPROCESSABLE_ENTITY'

    def initialize(message = 'Invalid', ast_node: nil, options: nil, extensions: {})
      super
    end
  end
end
