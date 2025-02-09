# frozen_string_literal: true

module Entity
  class Editor < Base
    class SupportError < StandardError; end

    attr_reader :entity

    def initialize(value:, entity:) # rubocop:disable Lint/MissingSuper
      @value = value
      @entity = entity
    end

    def edit
      case entity
      when Text
        edit_text
      when Link
        edit_link
      else
        raise SupportError, "type of #{entity.class} is unsupported"
      end

      entity
    end

    def edit_text
      entity.assign_attributes(body: value)
    end

    def edit_link
      entity.assign_attributes(url: uri.to_s)
    end

    class << self
      def edit(entity:, value:)
        new(entity:, value:).edit
      end
    end
  end
end
