require 'rails_helper'

RSpec.describe 'images/index', type: :view do
  before(:each) do
    @images = assign(:images, Kaminari.paginate_array(2.times.map { Fabricate(:image) }).page(1))
  end

  it 'renders a list of images' do
    html = render
    expect(html.scan(/img/).length).to eql(2)
    expect(html.scan(/a href/).length).to eql(2)
  end
end
