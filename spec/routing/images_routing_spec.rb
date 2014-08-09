require 'rails_helper'

RSpec.describe ImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/images').to route_to('images#index', user_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/images/new').to route_to('images#new', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/images/1').to route_to('images#show', user_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/images').to route_to('images#create', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/images/1').to route_to('images#destroy', user_id: '1', id: '1')
    end
  end
end
