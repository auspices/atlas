# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::RemoveCollectionSchema do
  let(:user) { Fabricate(:user) }
  let(:collection) do
    Fabricate(:collection, user: user, schema: {
      'fields' => {
        'year' => { 'type' => 'number', 'required' => true },
        'title' => { 'type' => 'string', 'required' => true }
      }
    })
  end

  let(:mutation) do
    <<~GQL
      mutation($id: ID!) {
        removeCollectionSchema(input: { id: $id }) {
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

  it 'removes the collection schema' do
    # Verify schema exists before mutation
    expect(collection.schema).to be_present
    expect(collection.schema_fields).to be_present

    variables = { id: collection.id }
    response = execute(mutation, current_user: user, variables: variables)

    expect(response['errors']).to be_nil
    expect(response['data']['removeCollectionSchema']['collection']).to be_present

    collection.reload
    expect(collection.schema).to be_nil
    expect(collection.schema_fields).to be_empty
  end
end 