# frozen_string_literal: true

module Errors
  class UnauthorizedError < Errors::BaseError
    CODE = 'UNAUTHORIZED'

    def initialize(message = 'Unauthorized', ast_node: nil, options: nil, extensions: {})
      super
    end
  end
end
