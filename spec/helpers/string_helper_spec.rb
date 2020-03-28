require 'rails_helper'

RSpec.describe StringHelper, type: :helper do
  describe '#truncate' do
    it 'returns back the passed in string if length is nil' do
      expect(truncate('example')).to eq('example')
    end

    describe 'tail' do
      it 'truncates using an ellipsis when given a length' do
        expect(truncate('example', length: 4)).to eq('exa…')
      end
    end

    describe 'center' do
      it 'truncates from the center' do
        expect(truncate('example', length: 4, from: :center)).to eq('e…le')
      end
    end

    describe 'head' do
      it 'truncates from the start' do
        expect(truncate('example', length: 4, from: :head)).to eq('…ple')
      end
    end

    describe 'urls' do
      it 'has sensible output for bare URLs' do
        expect(truncate('http://www.google.com/', length: 25))
          .to eq('www.google.com')
      end

      it 'has sensible output for bare URLs with short lengths' do
        expect(truncate('http://www.google.com/', length: 10))
          .to eq('google.com')
      end

      it 'has sensible output for long URLs' do
        expect(truncate('http://www.google.com/some/deep/path?whatever', length: 15, from: :center))
          .to eq("google…ep/path")
      end
    end
  end

  describe '#normalize_url' do
    it 'cleans up the url for printing' do
      expect(normalize_url('https://analytics.google.com/analytics/web/')).to eq('analytics.google.com/analytics/web')
    end
  end
end