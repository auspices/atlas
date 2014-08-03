require 'rails_helper'

RSpec.describe ImageProxyUrl do
  before(:each) do
    allow_any_instance_of(ImageProxyUrl).to receive(:embedly_key).and_return('xxx')
    allow_any_instance_of(ImageProxyUrl).to receive(:cloudfront_url).and_return('http://bucket.cloudfront.net')
  end

  it 'raises an error when the url option is missing' do
    expect { ImageProxyUrl.new }.to raise_error('Requires :url')
  end

  it 'sets some sensible defaults' do
    url = ImageProxyUrl.new(url: 'foobar')
    expect(url.method).to eql(:resize)
    expect(url.options[:height]).to eql(1000)
    expect(url.options[:width]).to eql(1000)
    expect(url.options[:quality]).to eql(95)
    expect(url.options[:key]).to eql('xxx')
  end

  it 'sets options and ignores keys not represented in ImageProxyUrl::QUERY_PARAMS' do
    url = ImageProxyUrl.new(url: 'foobar', foo: 'bar')
    expect(url.options[:foo]).to be_nil
  end

  it 'returns a usuable url' do
    url = ImageProxyUrl.new(url: 'foobar')
    expect(url.url).to eql('http://bucket.cloudfront.net/1/image/resize?height=1000&key=xxx&quality=95&url=foobar&width=1000')
  end
end
