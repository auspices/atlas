# frozen_string_literal: true

module Types
  class RawJson < BaseScalar
    def self.coerce_input(val, _ctx)
      val
    end

    def self.coerce_result(val, _ctx)
      val
    end
  end
end
