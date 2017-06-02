# frozen_string_literal: true

module Api
  module V1
    class BaseSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      root false
    end
  end
end
