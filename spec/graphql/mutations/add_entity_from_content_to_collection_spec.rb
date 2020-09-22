# frozen_string_literal: true

require 'rails_helper'

describe 'AddEntityFromContentToCollection' do
  let :mutation do
    <<-'GRAPHQL'
      mutation addEntityFromContentToCollection($id: ID!, $contentId: ID!) {
        addEntityFromContentToCollection(input: {id: $id, contentId: $contentId}) {
          collection {
            id
            contents {
              id
              entity {
                __typename
                ... on Image {
                  id
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

  let!(:existing_content) { Fabricate(:content, user: current_user) }

  let :variables do
    {
      id: collection.id,
      contentId: existing_content.id
    }
  end

  it 'adds the entity embedded in the content to the collection' do
    content = response['data']['addEntityFromContentToCollection']['collection']['contents'].first
    expect(content['entity']['id']).to be(existing_content.entity.id)
    expect(content['id']).not_to be(existing_content.id)
  end
end
