# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id                :integer          not null, primary key
#  title             :string
#  connections_count :integer          default(0)
#  user_id           :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#  slug              :string
#  metadata          :jsonb            not null
#

require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:collection) { Fabricate(:collection) }

  it 'has a valid fabricator' do
    expect(collection).to be_valid
  end
end
