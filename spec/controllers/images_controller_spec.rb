require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  let(:image) { Fabricate(:image) }
  let(:valid_attributes) { { source_url: 'http://source_url' } }
  let(:invalid_attributes) { { url: 'http://url' } }

  before(:each) do
    allow_any_instance_of(Image).to receive(:store!)
    allow_any_instance_of(Image).to receive(:remove_s3_object!)
    stub_const('ENV', { 'ADMIN_USERNAME' => 'username', 'ADMIN_PASSWORD' => 'password' })
    request.env['HTTP_AUTHORIZATION'] = "Basic #{Base64::encode64('username:password')}"
  end

  describe 'GET index' do
    it 'assigns all images as @images' do
      get :index
      expect(assigns(:images)).to eq([image])
    end
  end

  describe 'GET show' do
    it 'assigns the requested image as @image' do
      get :show, { id: image.to_param }
      expect(assigns(:image)).to eq(image)
    end
  end

  describe 'GET new' do
    it 'assigns a new image as @image' do
      get :new
      expect(assigns(:image)).to be_a_new(Image)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Image' do
        expect {
          post :create, { image: valid_attributes }
        }.to change(Image, :count).by(1)
      end

      it 'assigns a newly created image as @image' do
        post :create, { image: valid_attributes }
        expect(assigns(:image)).to be_a(Image)
        expect(assigns(:image)).to be_persisted
      end

      it 'redirects to the created image' do
        post :create, { image: valid_attributes }
        expect(response).to redirect_to(Image.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved image as @image' do
        post :create, { image: invalid_attributes }
        expect(assigns(:image)).to be_a_new(Image)
      end

      it 're-renders the "new" template' do
        post :create, { image: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) {
        { source_url: 'http://new_source_url' }
      }

      it 'updates the requested image' do
        image = Image.create! valid_attributes
        put :update, { id: image.to_param, image: new_attributes}
        image.reload
        expect(image.source_url).to eql('http://new_source_url')
      end

      it 'assigns the requested image as @image' do
        image = Image.create! valid_attributes
        put :update, { id: image.to_param, image: valid_attributes }
        expect(assigns(:image)).to eq(image)
      end

      it 'redirects to the image' do
        image = Image.create! valid_attributes
        put :update, { id: image.to_param, image: valid_attributes }
        expect(response).to redirect_to(image)
      end
    end

    describe 'with invalid params' do
      it 'assigns the image as @image' do
        image = Image.create! valid_attributes
        put :update, { id: image.to_param, image: invalid_attributes }
        expect(assigns(:image)).to eq(image)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested image' do
      image = Image.create! valid_attributes
      expect {
        delete :destroy, { id: image.to_param }
      }.to change(Image, :count).by(-1)
    end

    it 'redirects to the images list' do
      image = Image.create! valid_attributes
      delete :destroy, { id: image.to_param }
      expect(response).to redirect_to(images_url)
    end
  end
end
