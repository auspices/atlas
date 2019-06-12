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
end
