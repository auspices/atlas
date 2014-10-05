require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do
  let(:image) {
    Fabricate(:image)
  }

  let(:user) {
    Fabricate(:user, images: [image])
  }

  describe 'GET index' do
    it 'returns the JSON representation of a user\'s paginated images' do
      get :index, user_id: user.id
      expect(response.status).to be(200)
      parsed = JSON.parse(response.body)
      expect(parsed['total_count']).to be(1)
      expect(parsed['total_pages']).to be(1)
      expect(parsed['_embedded']['images']).to be_a(Array)
      expect(parsed['_embedded']['images'].first['id']).to eq(image.id)
      expect(parsed['_links'].keys).to eq(%w(self first next prev last))
    end
  end

  describe 'GET show' do
    it 'returns the JSON representation of a user\'s image' do
      get :show, user_id: user.id, id: image.id
      expect(response.status).to be(200)
      parsed = JSON.parse(response.body)
      expect(parsed['id']).to eq(image.id)
      expect(parsed['url']).to eq(image.url)
      expect(parsed['_links'].keys).to eq(%w(self images user))
    end
  end
end
