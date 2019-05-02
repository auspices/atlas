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
end
