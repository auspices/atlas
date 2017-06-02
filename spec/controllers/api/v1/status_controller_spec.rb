# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::StatusController, type: :controller do
  describe 'GET index' do
    it 'returns the system status' do
      get :index
      expect(response.body).to eq({ up: true }.to_json)
      expect(response.status).to be(200)
    end
  end
end
