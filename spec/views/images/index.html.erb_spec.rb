require 'rails_helper'

RSpec.describe 'images/index', type: :view do
  before(:each) do
    @images = assign(:images, Kaminari.paginate_array(2.times.map { Fabricate(:image) }).page(1))
  end

  describe 'logged out' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(false)
    end

    it 'renders a list of images' do
      expect(render.scan(/img/).length).to eql(2)
      expect(render.scan(/a href/).length).to eql(2)
    end

    it 'does not render the delete links' do
      expect(render).to_not include('image-delete-link')
    end
  end

  describe 'logged in' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(true)
    end

    it 'renders the delete links' do
      expect(render).to include('image-delete-link')
    end

    it 'renders the add link' do
      expect(render).to include('image-add-link')
    end
  end
end
