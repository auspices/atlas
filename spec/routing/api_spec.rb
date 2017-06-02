# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::StatusController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/status').to route_to('api/v1/status#index', format: 'json')
    end
  end
end
