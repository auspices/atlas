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

  describe 'metadata validation' do
    let(:collection) { Fabricate(:collection) }
    let(:content) { Fabricate.build(:content, collection: collection) }

    context 'when collection has no schema' do
      it 'is valid with any metadata' do
        content.metadata = { 'random' => 'data' }
        expect(content).to be_valid
      end
    end

    context 'when collection has a schema' do
      before do
        collection.schema = {
          'fields' => {
            'year' => { 'type' => 'number', 'required' => true },
            'title' => { 'type' => 'string', 'required' => true },
            'published' => { 'type' => 'boolean', 'required' => false }
          }
        }
        collection.save!
      end

      it 'is valid with conforming metadata' do
        content.metadata = {
          'year' => 2024,
          'title' => 'Test Title',
          'published' => true
        }
        expect(content).to be_valid
      end

      it 'is invalid with missing required fields' do
        content.metadata = { 'year' => 2024 }
        expect(content).not_to be_valid
        expect(content.errors[:metadata]).to include('title is required')
      end

      it 'is invalid with wrong types' do
        content.metadata = {
          'year' => '2024',
          'title' => 123,
          'published' => 'true'
        }
        expect(content).not_to be_valid
        expect(content.errors[:metadata]).to include('year must be a number')
        expect(content.errors[:metadata]).to include('title must be a string')
        expect(content.errors[:metadata]).to include('published must be a boolean')
      end

      it 'is valid with additional fields not in schema' do
        content.metadata = {
          'year' => 2024,
          'title' => 'Test Title',
          'extra' => 'field'
        }
        expect(content).to be_valid
      end
    end
  end
end
