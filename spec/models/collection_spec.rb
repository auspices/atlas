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

  describe 'schema validation' do
    context 'when schema is not present' do
      it 'is valid' do
        collection.schema = nil
        expect(collection).to be_valid
      end
    end

    context 'when schema is present' do
      it 'is valid with a proper schema structure' do
        collection.schema = {
          'fields' => {
            'year' => { 'type' => 'number', 'required' => true },
            'title' => { 'type' => 'string', 'required' => false },
            'published' => { 'type' => 'boolean', 'required' => false }
          }
        }
        expect(collection).to be_valid
      end

      it 'is invalid with improper schema structure' do
        collection.schema = { 'invalid' => 'schema' }
        expect(collection).not_to be_valid
        expect(collection.errors[:schema]).to include('must be a valid schema structure')
      end

      it 'is invalid with unknown type' do
        collection.schema = {
          'fields' => {
            'field' => { 'type' => 'unknown', 'required' => true }
          }
        }
        expect(collection).not_to be_valid
      end

      it 'is invalid without required field' do
        collection.schema = {
          'fields' => {
            'field' => { 'type' => 'string' }
          }
        }
        expect(collection).not_to be_valid
      end
    end
  end

  describe '#validate_content_metadata' do
    let(:collection) { Fabricate(:collection) }

    before do
      collection.schema = {
        'fields' => {
          'year' => { 'type' => 'number', 'required' => true },
          'title' => { 'type' => 'string', 'required' => true },
          'published' => { 'type' => 'boolean', 'required' => false }
        }
      }
    end

    it 'returns empty array for valid metadata' do
      metadata = {
        'year' => 2024,
        'title' => 'Test Title',
        'published' => true
      }
      expect(collection.validate_content_metadata(metadata)).to be_empty
    end

    it 'returns errors for missing required fields' do
      metadata = { 'year' => 2024 }
      errors = collection.validate_content_metadata(metadata)
      expect(errors).to include('title is required')
    end

    it 'returns errors for invalid types' do
      metadata = {
        'year' => '2024',
        'title' => 123,
        'published' => 'true'
      }
      errors = collection.validate_content_metadata(metadata)
      expect(errors).to include('year must be a number')
      expect(errors).to include('title must be a string')
      expect(errors).to include('published must be a boolean')
    end

    it 'allows optional fields to be omitted' do
      metadata = {
        'year' => 2024,
        'title' => 'Test Title'
      }
      expect(collection.validate_content_metadata(metadata)).to be_empty
    end
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

    it "returns true for circular references" do
      # Create collections
      collection1 = Fabricate(:collection)
      collection2 = Fabricate(:collection)
      collection3 = Fabricate(:collection)

      # Create contents with circular references
      Fabricate(:content, collection: collection1, entity: collection2)
      Fabricate(:content, collection: collection2, entity: collection3)
      Fabricate(:content, collection: collection3, entity: collection1)

      # Assert that contains_collection? returns true for the circular reference
      expect(collection1.contains_collection?(collection1.id)).to be(true)
      expect(collection2.contains_collection?(collection2.id)).to be(true)
      expect(collection3.contains_collection?(collection3.id)).to be(true)
    end

    it "returns false for circular references that don't include the target collection" do
      # Create collections
      collection1 = Fabricate(:collection)
      collection2 = Fabricate(:collection)
      collection3 = Fabricate(:collection)

      # Create contents with circular references
      Fabricate(:content, collection: collection1, entity: collection2)
      Fabricate(:content, collection: collection2, entity: collection3)
      Fabricate(:content, collection: collection3, entity: collection1)

      # Assert that contains_collection? returns false for the circular reference
      expect(collection1.contains_collection?(99999)).to be(false)
    end

    describe.skip 'with max_depth' do
      let(:collection) { Fabricate(:collection) }
      let(:target_collection_1) { Fabricate(:collection) }
      let(:target_collection_2) { Fabricate(:collection) }
      let(:target_collection_3) { Fabricate(:collection) }
  
      before do
        # Nest target collections inside each other
        collection.contents.create(entity: target_collection_1)
        target_collection_1.contents.create(entity: target_collection_2)
        target_collection_2.contents.create(entity: target_collection_3)
      end
  
      context 'when max_depth is specified' do
        it 'returns true if target collection is within the specified depth' do
          expect(collection.contains_collection?(target_collection_1.id, 1)).to be true
          expect(collection.contains_collection?(target_collection_2.id, 2)).to be true
        end
  
        it 'returns false if target collection is not within the specified depth' do
          expect(collection.contains_collection?(target_collection_2.id, 1)).to be false
          expect(collection.contains_collection?(target_collection_3.id, 2)).to be false
        end
      end
    end

    describe 'under stress' do
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
