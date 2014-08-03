require 'rails_helper'

RSpec.describe 'images/show', type: :view do
  before(:each) do
    allow_any_instance_of(Image).to receive(:store!)
    @image = assign(:image, Fabricate(:image))
  end

  it 'renders attributes in the .full-image wrapper' do
    expect(render).to include('full-image')
  end
end
