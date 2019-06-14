# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id         :bigint           not null, primary key
#  url        :text
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link) { Fabricate(:link) }

  it 'has a valid fabricator' do
    expect(link).to be_valid
  end

  describe '#truncated_url' do
    it 'has sensible output for bare URLs' do
      expect(Link.new(url: 'http://www.google.com/').truncated_url(length: 25))
        .to eq('www.google.com')
    end

    it 'has sensible output for bare URLs with short lengths' do
      expect(Link.new(url: 'http://www.google.com/').truncated_url(length: 10))
        .to eq('google.com')
    end

    it 'has sensible output for long URLs' do
      expect(Link.new(url: 'http://www.google.com/some/deep/path?whatever').truncated_url(length: 20))
        .to eq('google..../deep/path')
    end
  end
end
