require 'rails_helper'

RSpec.describe 'Images', type: :request do
  describe 'GET /images' do
    it 'works' do
      get images_path
      expect(response.status).to be(200)
    end
  end
end
