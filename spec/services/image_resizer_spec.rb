# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageResizer do
  let(:image) { Fabricate(:image) }

  it 'sets up geometry (1)' do
    resized = ImageResizer.new(image, width: 300)
    expect(image.width).to eql(800)
    expect(image.height).to eql(600)
    expect(resized.target_width).to eql(300)
    expect(resized.target_height).to eql(0)
    expect(resized.width).to eql(300)
    expect(resized.height).to eql(225)
  end

  it 'sets up geometry (2)' do
    resized = ImageResizer.new(image, width: 225, height: 25)
    expect(image.width).to eql(800)
    expect(image.height).to eql(600)
    expect(resized.target_width).to eql(225)
    expect(resized.target_height).to eql(25)
    expect(resized.width).to eql(33)
    expect(resized.height).to eql(25)
  end

  it 'gracefully deals with nils (1)' do
    resized = ImageResizer.new(image, width: nil, height: nil)
    expect(image.width).to eql(800)
    expect(image.height).to eql(600)
    expect(resized.target_width).to eql(0)
    expect(resized.target_height).to eql(0)
    expect(resized.width).to eql(0)
    expect(resized.height).to eql(0)
  end

  it 'gracefully deals with nils (2)' do
    image.update_attributes!(width: nil, height: nil)
    resized = ImageResizer.new(image, width: 800, height: 600)
    expect(image.width).to be_nil
    expect(image.height).to be_nil
    expect(resized.target_width).to be_nil
    expect(resized.target_height).to be_nil
    expect(resized.url).to include('/resize///http%3A%2F%2Fbucket.com%2F1%2Fbar.jpg')
  end

  describe 'url' do
    it 'delegates to ImageProxyUrl with target options' do
      expect(ImageResizer.new(image, width: 300).url)
        .to include '/resize/300/0/http%3A%2F%2Fbucket.com%2F1%2Fbar.jpg'
    end
  end
end
