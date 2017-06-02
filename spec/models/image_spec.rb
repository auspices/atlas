# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  url        :text
#  source_url :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  width      :integer
#  height     :integer
#

require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:image) { Fabricate(:image) }

  it 'has a valid fabricator' do
    expect(image).to be_valid
  end

  it 'returns the key of the s3 object for the stored url' do
    expect(image.url_key).to eql('1/bar.jpg')
  end

  describe 'store!' do
    before(:each) do
      allow_any_instance_of(ImageMover).to receive(:fallback_extension).and_return(nil)
    end

    it 'errors correctly when presented with an inappropriate source_url' do
      image = Image.new(user: Fabricate(:user), source_url: 'http://foo.com/bar')
      expect(image).to be_invalid
      image.source_url = image.source_url << '.jpg'
      expect(image).to be_valid
    end
  end
end
