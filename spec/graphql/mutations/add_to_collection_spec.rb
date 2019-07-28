# frozen_string_literal: true

require 'rails_helper'

describe 'AddToCollection' do
  let :mutation do
    <<-'GRAPHQL'
      mutation addToCollection($id: ID!, $value: String!, $metadata: JSON) {
        addToCollection(input: { id: $id, value: $value, metadata: $metadata }) {
          collection {
            id
            contents {
              id
              metadata
              entity {
                __typename
                ... on Text {
                  id
                  body
                }
              }
            }
          }
        }
      }
    GRAPHQL
  end

  let!(:current_user) { Fabricate(:user) }
  let!(:collection) { Fabricate(:collection, user: current_user) }

  let :response do
    execute mutation, {
      current_user: current_user,
      variables: {
        id: collection.id,
        value: 'Hello world',
        metadata: {
          foo: 'bar',
          bar: 'baz'
        }.to_json
      }
    }
  end

  it 'adds to the collection' do
    content = response['data']['addToCollection']['collection']['contents'].first
    expect(content['metadata']['foo']).to eql('bar')
    expect(content['metadata']['bar']).to eql('baz')
    expect(content['entity']['__typename']).to eql('Text')
    expect(content['entity']['body']).to eql('Hello world')
  end
end
