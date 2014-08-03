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
  let(:image) { Fabricate(:image) }

  it 'has a valid fabricator' do
    expect(image).to be_valid
  end

  it 'returns the key of the s3 object for the stored url' do
    expect(image.url_key).to eql('1/bar.jpg')
  end
end
