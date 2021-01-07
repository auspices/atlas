# frozen_string_literal: true

require 'rails_helper'

describe 'AddToCollection' do
  let :mutation do
    <<-'GRAPHQL'
      mutation addToCollection($id: ID!, $value: String!, $metadata: JSON) {
        addToCollection(input: { id: $id, value: $value, metadata: $metadata }) {
          collection {
            id
            title
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
  let!(:collection) { Fabricate(:collection, user: current_user, title: "A Collection") }

  let :response do
    execute mutation,
      current_user: current_user,
      variables: variables
  end

  let :variables do
    {
      id: collection.id,
      value: 'Goodbye world'
    }
  end

  it 'adds to the collection' do
    content = response['data']['addToCollection']['collection']['contents'].first
    expect(content['entity']['__typename']).to eql('Text')
    expect(content['entity']['body']).to eql('Goodbye world')
  end


  describe 'with metadata' do
    let :variables do
      {
        id: collection.id,
        value: 'Hello world',
        metadata: {
          foo: 'bar',
          bar: 'baz'
        }.to_json
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

  describe 'a collection whose slug conflicts with a numeric id' do
    let!(:collection_with_conflicting_slug_id) { Fabricate(:collection, user: current_user, title: collection.id) }

    it 'requires the id (not slug) of the collection for adding' do
      response_collection = response['data']['addToCollection']['collection']
      content = response['data']['addToCollection']['collection']['contents'].first
      expect(response_collection['id']).to eql(collection.id)
      expect(response_collection['title']).to eql("A Collection")
      expect(content['entity']['__typename']).to eql('Text')
      expect(content['entity']['body']).to eql('Goodbye world')
    end
  end
end
