require 'rails_helper'

RSpec.describe SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/login').to route_to('sessions#new')
    end

    it 'routes to #create' do
      expect(post: '/sessions').to route_to('sessions#create')
    end

    it 'routes to #destroy' do
      expect(get: '/logout').to route_to('sessions#destroy')
    end
  end
end

RSpec.describe CollectionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/username').to route_to('collections#index', user_id: 'username')
    end

    it 'routes to #show' do
      expect(get: '/username/1').to route_to('collections#show', user_id: 'username', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/username').to route_to('collections#create', user_id: 'username')
    end

    it 'routes to #destroy' do
      expect(delete: '/username/1').to route_to('collections#destroy', user_id: 'username', id: '1')
    end
  end
end

RSpec.describe ImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/username/images').to route_to('images#index', user_id: 'username')
    end

    it 'routes to #show' do
      expect(get: '/username/images/1').to route_to('images#show', user_id: 'username', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/username/images').to route_to('images#create', user_id: 'username')
    end

    it 'routes to #destroy' do
      expect(delete: '/username/images/1').to route_to('images#destroy', user_id: 'username', id: '1')
    end
  end
end

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
    end

    it 'routes to #new' do
      expect(get: '/users/new').to route_to('users#new')
      expect(get: '/register').to route_to('users#new')
    end

    it 'routes to #show' do
      expect(get: '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/edit').to route_to('users#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users').to route_to('users#create')
    end

    it 'routes to #update' do
      expect(put: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1').to route_to('users#destroy', id: '1')
    end
  end
end
