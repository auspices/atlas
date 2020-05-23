# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id             :integer          not null, primary key
#  title          :string
#  contents_count :integer          default(0)
#  user_id        :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#  slug           :string
#  metadata       :jsonb            not null
#  key            :uuid
#

require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:collection) { Fabricate(:collection) }

  it 'has a valid fabricator' do
    expect(collection).to be_valid
  end

  describe 'relationships' do
    let(:user) { Fabricate(:user) }

    describe 'collections' do
      let(:nested_collection) do
        Fabricate(:collection).tap do |xs|
          xs.contents.create!(user: user, entity: nested_text)
        end
      end

      let(:nested_text) { Fabricate(:text) }
      let(:text) { Fabricate(:text) }

      it 'cleans up associated content' do
        collection.contents.create!(user: user, entity: nested_collection)
        collection.contents.create!(user: user, entity: nested_text)
        collection.contents.create!(user: user, entity: text)

        expect(collection.contents.size).to be(3)
        expect(nested_collection.persisted?).to be(true)

        nested_collection.destroy

        collection.contents.reload
        expect(collection.contents.size).to be(2)
        expect(collection.contents.pluck(:entity_type)).to eql(['Text', 'Text'])

        expect(nested_collection.persisted?).to be(false)
        expect(nested_text.persisted?).to be(true)
        expect(text.persisted?).to be(true)
      end
    end
  end
end
