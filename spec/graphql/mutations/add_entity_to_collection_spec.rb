# frozen_string_literal: true

require 'rails_helper'

describe 'AddEntityToCollection' do
  let :mutation do
    <<-'GRAPHQL'
      mutation addEntityToCollection($id: ID!, $entity: EntityInput!) {
        addEntityToCollection(input: {id: $id, entity: $entity}) {
          collection {
            id
            contents {
              id
              entity {
                __typename
                ... on Collection {
                  id
                  title
                }
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
    execute mutation,
      current_user: current_user,
      variables: variables
  end

  describe 'collections' do
    let!(:nested) { Fabricate(:collection, user: current_user, title: 'Nested') }

    let :variables do
      {
        id: collection.id,
        entity: {
          id: nested.id, type: "COLLECTION"
        }
      }
    end

    it 'adds the collection to the collection' do
      content = response['data']['addEntityToCollection']['collection']['contents'].first
      expect(content['entity']['__typename']).to eql('Collection')
      expect(content['entity']['title']).to eql('Nested')
    end

    describe 'error' do
      let :variables do
        {
          id: collection.id,
          entity: {
            id: 666666, type: "COLLECTION"
          }
        }
      end

      it 'errors if it cannot find the collection to add' do
        expect(response['errors'].first['extensions']['code']).to eql('NOT_FOUND')
      end
    end
  end

  describe 'images' do
    let!(:nested) { Fabricate(:text, user: current_user) }

    let :variables do
      {
        id: collection.id,
        entity: {
          id: nested.id, type: "TEXT"
        }
      }
    end

    it 'adds the collection to the collection' do
      content = response['data']['addEntityToCollection']['collection']['contents'].first
      expect(content['entity']['__typename']).to eql('Text')
      expect(content['entity']['body']).to eql('Hello world')
    end
  end
end
