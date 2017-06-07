# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collections::ImagesController, type: :controller do
  let :user do
    Fabricate :user
  end

  # let :image do
  #   Fabricate :image, user: user
  # end

  let :collection do
    Fabricate :collection,  user: user
  end

  let :source_url do
    'http://example.com/bar.jpg'
  end

  before(:each) do
    allow_any_instance_of(Image).to receive(:store!)
    allow_any_instance_of(Image).to receive(:remove_s3_object!)
  end

  describe 'logged in' do
    before :each do
      login_user user
    end

    describe 'GET add' do
      it 'creates a new Image' do
        expect do
          get :add, user_id: user.id, collection_id: collection.id, source_url: source_url
        end.to change(Image, :count).by(1)
      end

      it 'assigns a newly created image as @image' do
        get :add, user_id: user.id, collection_id: collection.id, source_url: source_url
        expect(assigns(:image)).to be_a(Image)
        expect(assigns(:image)).to be_persisted
      end

      it 'redirects to the created image' do
        get :add, user_id: user.id, collection_id: collection.id, source_url: source_url
        expect(response).to redirect_to([user, collection])
      end
    end
  end
end
