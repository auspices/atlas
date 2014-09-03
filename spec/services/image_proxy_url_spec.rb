require 'rails_helper'

RSpec.describe ImageProxyUrl do
  it 'raises an error when the url option is missing' do
    expect { ImageProxyUrl.new }.to raise_error('Requires :url')
  end

  it 'sets some sensible defaults' do
    url = ImageProxyUrl.new(url: 'http://foobar.s3.amazonaws.com/id/image.jpg')
    expect(url.options[:h]).to eql(1000)
    expect(url.options[:w]).to eql(1000)
    expect(url.options[:q]).to eql(90)
  end

  it 'sets options and ignores keys not represented in ImageProxyUrl::QUERY_PARAMS' do
    url = ImageProxyUrl.new(url: 'http://foobar.s3.amazonaws.com/id/image.jpg', foo: 'bar')
    expect(url.options[:foo]).to be_nil
  end

  it 'returns a usuable url' do
    url = ImageProxyUrl.new(url: 'http://foobar.s3.amazonaws.com/id/image.jpg')
    expect(url.url).to eql('https://d1db8csqyunu31.cloudfront.net/resize?h=1000&q=90&url=http%3A%2F%2Ffoobar.s3.amazonaws.com%2Fid%2Fimage.jpg&w=1000')
  end
end
