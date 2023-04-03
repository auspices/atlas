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

  describe '#contains_collection?' do
    let(:user) { Fabricate(:user) }

    let(:nested_collection) do
      Fabricate(:collection)
    end

    let(:unnested_collection) do
      Fabricate(:collection)
    end

    let(:deeply_nested_collection) do
      Fabricate(:collection)
    end

    it 'returns true if the collection contains the target collection' do
      collection.contents.create!(user: user, entity: nested_collection)

      expect(collection.contains_collection?(nested_collection.id)).to be(true)
    end

    it 'returns false if the collection does not contain the target collection' do
      expect(collection.contains_collection?(unnested_collection.id)).to be(false)
    end

    it 'detects a deeply nested collection' do
      collection.contents.create!(user: user, entity: nested_collection)
      nested_collection.contents.create!(user: user, entity: deeply_nested_collection)

      expect(collection.contains_collection?(deeply_nested_collection.id)).to be(true)
    end

    it 'detects a collection nested multiple levels deep' do
      collection_a = Fabricate(:collection)
      collection_b = Fabricate(:collection)
      collection_c = Fabricate(:collection)
      collection_d = Fabricate(:collection)
  
      collection_a.contents.create!(user: user, entity: collection_b)
      collection_b.contents.create!(user: user, entity: collection_c)
      collection_c.contents.create!(user: user, entity: collection_d)
  
      expect(collection_a.contains_collection?(collection_d.id)).to be(true)
    end
  
    it 'detects a collection in another branch of the tree' do
      collection_a = Fabricate(:collection)
      collection_b = Fabricate(:collection)
      collection_c = Fabricate(:collection)
      collection_d = Fabricate(:collection)
      collection_e = Fabricate(:collection)
  
      collection_a.contents.create!(user: user, entity: collection_b)
      collection_a.contents.create!(user: user, entity: collection_c)
      collection_b.contents.create!(user: user, entity: collection_d)
      collection_c.contents.create!(user: user, entity: collection_e)
  
      expect(collection_a.contains_collection?(collection_e.id)).to be(true)
    end

    describe 'under stress', focus: true do
      let!(:root_collection) { Fabricate(:collection) }
      let!(:nested_collections) { Fabricate.times(10, :collection) }
      let!(:deeply_nested_collections) { Fabricate.times(10, :collection) }

      before do
        # Create the structure of nested collections
        nested_collections.each_with_index do |collection, index|
          Fabricate(:content, collection: index.zero? ? root_collection : nested_collections[index - 1], entity: collection)
        end

        deeply_nested_collections.each_with_index do |collection, index|
          Fabricate(:content, collection: index.zero? ? nested_collections.last : deeply_nested_collections[index - 1], entity: collection)
        end
      end

      it 'handles stress test with multiple parallel queries' do
        stress_test_threads = []

        # Run 20 parallel queries
        20.times do
          stress_test_threads << Thread.new do
            10.times do
              expect(root_collection.contains_collection?(deeply_nested_collections.sample.id)).to be(true)
            end
          end
        end

        # Wait for all threads to finish
        stress_test_threads.each(&:join)
      end
    end
  end
end
