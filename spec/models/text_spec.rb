# == Schema Information
#
# Table name: texts
#
#  id         :bigint           not null, primary key
#  body       :text
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Text, type: :model do
  let(:text) { Fabricate(:text) }

  it 'has a valid fabricator' do
    expect(text).to be_valid
  end
end
