require 'rails_helper'

RSpec.describe Api::V1::CollectionsController, type: :controller do
  let(:collection) {
    Fabricate(:collection)
  }

  let(:user) {
    Fabricate(:user, collections: [collection])
  }

  describe 'GET index' do
    it 'returns the JSON representation of a user\'s paginated collections' do
      get :index, user_id: user.id
      expect(response.status).to be(200)
      parsed = JSON.parse(response.body)
      expect(parsed['total_count']).to be(1)
      expect(parsed['total_pages']).to be(1)
      expect(parsed['_embedded']['collections']).to be_a(Array)
      expect(parsed['_embedded']['collections'].first['id']).to eq(collection.id)
      expect(parsed['_links'].keys).to eq(['self', 'next', 'prev'])
    end
  end

  describe 'GET show' do
    it 'returns the JSON representation of a user\'s collection' do
      get :show, user_id: user.id, id: collection.id
      expect(response.status).to be(200)
      parsed = JSON.parse(response.body)
      expect(parsed['id']).to eq(collection.id)
      expect(parsed['title']).to eq(collection.title)
      expect(parsed['_links'].keys).to eq(['self', 'images', 'user'])
    end
  end
end
