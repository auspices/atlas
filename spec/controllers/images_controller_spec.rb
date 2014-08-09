require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  let(:user) {
    Fabricate(:user)
  }

  let(:image) {
    Fabricate(:image, user: user)
  }

  let(:another_image) {
    Fabricate(:image)
  }

  let(:valid_attributes) {
    { source_url: 'http://source_url' }
  }

  let(:invalid_attributes) {
    { url: 'http://url' }
  }

  before(:each) do
    allow_any_instance_of(Image).to receive(:store!)
    allow_any_instance_of(Image).to receive(:remove_s3_object!)
  end

  describe 'logged out' do
    describe 'GET index' do
      it 'assigns a users images as @images' do
        get :index, user_id: user.id
        expect(assigns(:images)).to eq([image])
        expect(assigns(:images).first.user_id).to eq(user.id)
      end
    end

    describe 'GET show' do
      it 'assigns the requested image as @image' do
        get :show, id: image.to_param, user_id: user.id
        expect(assigns(:image)).to eq(image)
      end
    end
  end

  describe 'logged in' do
    before(:each) do
      @current_user = Fabricate(:user, email: 'admin@example.com', username: 'admin', password: 'secret')
      login_user @current_user
    end

    describe 'GET new' do
      it 'assigns a new image as @image' do
        get :new, user_id: @current_user.id
        expect(assigns(:image)).to be_a_new(Image)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'creates a new Image' do
          expect {
            post :create, user_id: @current_user.id, image: valid_attributes
          }.to change(Image, :count).by(1)
        end

        it 'assigns a newly created image as @image' do
          post :create, user_id: @current_user.id, image: valid_attributes
          expect(assigns(:image)).to be_a(Image)
          expect(assigns(:image)).to be_persisted
        end

        it 'redirects to the created image' do
          post :create, user_id: @current_user.id, image: valid_attributes
          expect(response).to redirect_to([@current_user, Image.last])
        end

        it 'prevents users from creating other users images' do
          post :create, user_id: user.id, image: valid_attributes
          expect(assigns(:image).user_id).to be(@current_user.id)
          expect(assigns(:image).user_id).not_to be(user.id)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved image as @image' do
          post :create, user_id: @current_user.id, image: invalid_attributes
          expect(assigns(:image)).to be_a_new(Image)
        end

        it 're-renders the "new" template' do
          post :create, user_id: @current_user.id, image: invalid_attributes
          expect(response).to render_template('new')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested image' do
        image = Fabricate(:image, user: @current_user)
        expect {
          delete :destroy, user_id: @current_user.id, id: image.id
        }.to change(Image, :count).by(-1)
      end

      it 'prevents destruction of non-owned images' do
        image = Fabricate(:image, user: user)
        expect {
          delete :destroy, user_id: user.id, id: image.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'redirects to the root' do
        image = Fabricate(:image, user: @current_user)
        delete :destroy, user_id: @current_user.id, id: image.id
        expect(response).to redirect_to(:root)
      end
    end
  end
end
