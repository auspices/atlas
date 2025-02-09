# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateCollectionSchema do
  let(:user) { Fabricate(:user) }
  let(:collection) { Fabricate(:collection, user: user) }

  let(:schema_fields) do
    [
      {
        name: 'year',
        type: 'NUMBER',
        required: true
      },
      {
        name: 'title',
        type: 'STRING',
        required: true
      },
      {
        name: 'published',
        type: 'BOOLEAN',
        required: false
      }
    ]
  end

  let(:mutation) do
    <<~GQL
      mutation($id: ID!, $schemaFields: [SchemaFieldInput!]!) {
        updateCollectionSchema(input: { id: $id, schemaFields: $schemaFields }) {
          collection {
            id
            schema
            schemaFields {
              name
              type
              required
            }
          }
        }
      }
    GQL
  end

  it 'updates the collection schema' do
    variables = {
      id: collection.id,
      schemaFields: schema_fields
    }

    response = execute(mutation, current_user: user, variables: variables)

    expect(response['errors']).to be_nil
    expect(response['data']['updateCollectionSchema']['collection']).to be_present

    collection.reload
    expect(collection.schema).to be_present
    expect(collection.schema_fields.keys).to match_array(%w[year title published])
  end

  it 'validates schema field types' do
    variables = {
      id: collection.id,
      schemaFields: [
        {
          name: 'invalid',
          type: 'UNKNOWN',
          required: true
        }
      ]
    }

    response = execute(mutation, current_user: user, variables: variables)

    expect(response['errors']).to be_present
    expect(response['errors'].first['message']).to include('UNKNOWN')
  end
end 