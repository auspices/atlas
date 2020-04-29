# frozen_string_literal: true

module HasUrl
  extend ActiveSupport::Concern

  URL_BUILDER = UrlBuilder.new

  module ClassMethods
    attr_reader :has_url_template

    private

    # rubocop:disable Naming/PredicateName
    def has_url(template:)
      @has_url_template = template
    end
    # rubocop:enable Naming/PredicateName
  end

  def to_url(absolute: nil)
    @to_url ||= URL_BUILDER.to_s(options: instance_exec(&self.class.has_url_template), absolute: absolute)
  end
end
