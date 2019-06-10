# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id            :integer          not null, primary key
#  collection_id :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer
#  entity_type   :string
#  entity_id     :bigint
#  metadata      :jsonb            not null
#

require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:content) { Fabricate(:content) }

  it 'has a valid fabricator' do
    expect(content).to be_valid
  end
end
