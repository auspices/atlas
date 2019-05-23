# frozen_string_literal: true

# == Schema Information
#
# Table name: connections
#
#  id            :integer          not null, primary key
#  collection_id :integer          not null
#  image_id      :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer
#

require 'rails_helper'

RSpec.describe Connection, type: :model do
  let(:connection) { Fabricate(:connection) }

  it 'has a valid fabricator' do
    expect(connection).to be_valid
  end
end
