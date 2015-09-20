require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      email: 'new@example.com',
      username: 'new_user',
      password: 'secret',
      password_confirmation: 'secret'
    }
  end

  let(:invalid_attributes) do
    {
      email: 'new@example.com',
      username: 'new_user',
      password: 'secret',
      password_confirmation: 'whatever'
    }
  end

  before(:each) do
    login_user Fabricate(:user, email: 'admin@example.com', username: 'admin', password: 'secret')
  end

  describe 'POST create' do
    it 'registers a new user' do
      post :create, user: valid_attributes
      expect(assigns(:user).email).to eq('new@example.com')
      expect(response).to redirect_to(assigns(:user))
    end

    it 'does not register a new user if the passwords do not match' do
      post :create, user: invalid_attributes
      expect(response.status).to be(200)
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete :destroy, id: user.to_param
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete :destroy, id: user.to_param
      expect(response).to redirect_to(users_url)
    end
  end
end
