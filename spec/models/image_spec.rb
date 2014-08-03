# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  url        :text
#  source_url :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Image, type: :model do
  before(:each) do
    allow_any_instance_of(ImageMover).to receive(:move!).and_return('http://bucket.com/1/bar.jpg')
  end

  let(:image) { Fabricate(:image) }

  it 'has a valid fabricator' do
    expect(image).to be_valid
  end

  it 'sets the url based on the ImageMover response' do
    expect(image.url).to eql('http://bucket.com/1/bar.jpg')
  end

  it 'returns the key of the s3 object for the stored url' do
    expect(image.url_key).to eql('1/bar.jpg')
  end
end
