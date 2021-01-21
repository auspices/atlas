# frozen_string_literal: true

require 'rails_helper'

describe 'AddToCollections' do
  let :mutation do
    <<-'GRAPHQL'
      mutation addToCollections($ids: [ID!]!, $value: String!, $metadata: JSON) {
        addToCollections(input: { ids: $ids, value: $value, metadata: $metadata }) {
          collections {
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

  let!(:collections) do
    [
      Fabricate(:collection, user: current_user),
      Fabricate(:collection, user: current_user),
      Fabricate(:collection, user: current_user)
    ]
  end

  let :response do
    execute mutation,
      current_user: current_user,
      variables: variables
  end

  let :variables do
    {
      ids: collections.map(&:id),
      value: 'Goodbye world'
    }
  end

  it 'adds to the collections' do
    content = response['data']['addToCollections']['collections'].first['contents'].first
    expect(content['entity']['__typename']).to eql('Text')
    expect(content['entity']['body']).to eql('Goodbye world')
  end

  it 'creates a single entity' do
    expect { response }.to change { Text.count }.by(1)
  end

  it 'creates three contents' do
    expect { response }.to change { Content.count }.by(3)
  end


  describe 'with metadata' do
    let :variables do
      {
        ids: collections.map(&:id),
        value: 'Hello world',
        metadata: {
          foo: 'bar',
          bar: 'baz'
        }.to_json
      }
    end

    it 'adds to the collections' do
      content = response['data']['addToCollections']['collections'].first['contents'].first
      expect(content['metadata']['foo']).to eql('bar')
      expect(content['metadata']['bar']).to eql('baz')
      expect(content['entity']['__typename']).to eql('Text')
      expect(content['entity']['body']).to eql('Hello world')
    end
  end
end
