require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:each) do
    Fabricate(:user, username: 'new_user', password: 'secret')
  end

  describe 'GET new' do
    it 'assigns a new user as @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    it 'logs the user in' do
      post :create, username: 'new_user', password: 'secret'
      expect(controller.logged_in?).to be(true)
      expect(response).to redirect_to(:root)
      expect(flash[:notice]).to eql('Hello')
    end

    it 're-renders the login form for failed logins' do
      post :create, username: 'new_user', password: 'bad_password'
      expect(controller.logged_in?).to be(false)
      expect(response.status).to be(200)
      expect(flash[:alert]).to eql('Login failed')
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      post :create, username: 'new_user', password: 'secret'
      expect(controller.logged_in?).to be(true)
    end

    it 'logs the user out and redirects home' do
      delete :destroy
      expect(controller.logged_in?).to be(false)
      expect(response).to redirect_to(:root)
      expect(flash[:notice]).to eql('Goodbye')
    end
  end
end
