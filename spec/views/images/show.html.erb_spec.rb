require 'rails_helper'

RSpec.describe 'images/show', type: :view do
  before(:each) do
    allow_any_instance_of(Image).to receive(:store!)
    @image = assign(:image, Fabricate(:image))
  end

  describe 'logged out' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(false)
    end

    it 'renders attributes in the .image-show-stage wrapper' do
      expect(render).to include('image-show-stage')
    end

    it 'does not render the delete link' do
      expect(render).to_not include('image-delete-link')
    end
  end

  describe 'logged in' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(true)
    end

    it 'renders the delete link' do
      expect(render).to include('image-delete-link')
    end
  end
end
