# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageMover do
  describe 'key' do
    it 'returns the appropriate key' do
      image = Fabricate(:image, source_url: 'https://s3.amazonaws.com/foobar/foobar/original_foobar.jpg')
      expect(image.id).to be_an(Integer)
      expect(ImageMover.new(image).key).to eql("#{image.id}/7e5f8b8b693827ac490dd3463a463b467cb5b43e9d063246129a2983b55c6ddc.jpg")
    end

    it 'returns the appropriate key when URL has a query string' do
      image = Fabricate(:image, source_url: 'https://s3.amazonaws.com/foobar/foobar/original_foobar.jpg?foo=bar')
      expect(image.id).to be_an(Integer)
      expect(ImageMover.new(image).key).to eql("#{image.id}/bec2af2a5003574e7309f527e5e57e1e1fad10913d9310e388baeaf312e3156e.jpg")
    end

    it 'hits the fallback method when there is no extension' do
      allow_any_instance_of(ImageMover).to receive(:fallback_extension).and_return('.png')
      image = Fabricate(:image, source_url: 'http://stephensykes.com/images/pngimage')
      expect(ImageMover.new(image).key).to eql("#{image.id}/52641535f82005727da4d9d48989c60be353a96a2fe7839e0ae53440a21336b4.png")
    end
  end
end
