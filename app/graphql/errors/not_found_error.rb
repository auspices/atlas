# frozen_string_literal: true

module Errors
  class NotFoundError < Errors::BaseError
    CODE = 'NOT_FOUND'

    def initialize(message = 'Not found', ast_node: nil, options: nil, extensions: {})
      super
    end
  end
end
