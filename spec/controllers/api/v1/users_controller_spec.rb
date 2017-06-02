# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) do
    Fabricate(:user, slug: 'foobar')
  end

  describe 'GET show' do
    it 'returns the JSON representation of the requested user' do
      get :show, id: user.id
      expect(response.status).to be(200)
      parsed = JSON.parse(response.body)
      expect(parsed['slug']).to eq('foobar')
      expect(parsed['_links']['self']['href']).to include('api/users/foobar')
      expect(parsed['_links']['images']['href']).to include('api/users/foobar/images')
      expect(parsed['_links']['collections']['href']).to include('api/users/foobar/collections')
    end
  end
end
