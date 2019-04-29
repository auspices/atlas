# frozen_string_literal: true

module Errors
  class BadRequestError < Errors::BaseError
    CODE = 'BAD_REQUEST'

    def initialize(message = 'Bad request', ast_node: nil, options: nil, extensions: {})
      super
    end
  end
end
