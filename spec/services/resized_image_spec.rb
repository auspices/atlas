# frozen_string_literal: true

require 'rails_helper'

describe 'ResizedImage' do
  let(:landscape) { Fabricate(:image, width: 640, height: 480) }
  let(:portrait) { Fabricate(:image, width: 480, height: 640) }

  describe 'fit: inside' do
    it 'requires either the width or height' do
      expect(-> { landscape.resized(fit: 'inside') }).to raise_error(ArgumentError)
      expect(landscape.resized(width: 250, fit: 'inside').width).to eq(250)
      expect(landscape.resized(width: 250, fit: 'inside').height).to eq(187)
      expect(landscape.resized(height: 250, fit: 'inside').width).to eq(333)
      expect(landscape.resized(height: 250, fit: 'inside').height).to eq(250)
    end

    it 'resizes the dimensions proportionally' do
      resized_landscape = landscape.resized(width: 250, height: 250, fit: 'inside')
      expect(resized_landscape.width).to eq(250)
      expect(resized_landscape.height).to eq(187)
      expect(resized_landscape.factor).to eq(0.390625)
      expect(resized_landscape.ratio).to eq(74.8)
      
      resized_portrait = portrait.resized(width: 250, height: 250, fit: 'inside')
      expect(resized_portrait.width).to eq(187)
      expect(resized_portrait.height).to eq(250)
      expect(resized_portrait.factor).to eq(0.390625)
      expect(resized_portrait.ratio).to eq(133.6898395721925)
    end
  end

  describe 'fit: cover' do
    it 'requires both the width and height' do
      expect(-> { landscape.resized(fit: 'cover') }).to raise_error(ArgumentError)
      expect(-> { landscape.resized(width: 250, fit: 'cover') }).to raise_error(ArgumentError)
      expect(-> { landscape.resized(height: 250, fit: 'cover') }).to raise_error(ArgumentError)
    end

    it 'crops the dimensions' do
      resized_landscape = landscape.resized(width: 250, height: 250, fit: 'cover')
      expect(resized_landscape.width).to eq(250)
      expect(resized_landscape.height).to eq(250)
      expect(resized_landscape.factor).to eq(0.390625)
      expect(resized_landscape.ratio).to eq(100)
      
      resized_portrait = portrait.resized(width: 250, height: 250, fit: 'cover')
      expect(resized_portrait.width).to eq(250)
      expect(resized_portrait.height).to eq(250)
      expect(resized_portrait.factor).to eq(0.390625)
      expect(resized_portrait.ratio).to eq(100)
    end
  end
end
