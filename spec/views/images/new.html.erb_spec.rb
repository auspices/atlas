require 'rails_helper'

RSpec.describe 'images/new', type: :view do
  before(:each) do
    assign(:image, Image.new)
  end

  it 'renders new image form' do
    expect(render).to include('image[source_url]')
  end
end
