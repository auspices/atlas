# frozen_string_literal: true

require 'rails_helper'

describe 'DeleteCollection' do
  let :mutation do
    <<-'GRAPHQL'
      mutation deleteCollection($id: ID!) {
        deleteCollection(input: { id: $id }) {
          me {
            collections {
              id
              name
            }
          }
        }
      }
    GRAPHQL
  end

  let!(:current_user) { Fabricate(:user) }
  let!(:keeping_collection) { Fabricate(:collection, title: 'To Keep', user: current_user) }
  let!(:deleting_collection) { Fabricate(:collection, title: 'To Delete', user: current_user) }

  let :response do
    execute mutation,
      current_user: current_user,
      variables: variables
  end

  let :variables do
    { id: deleting_collection.id }
  end

  it 'deletes the collection' do
    expect(current_user.collections.count).to be(2)
    collections = response['data']['deleteCollection']['me']['collections']
    current_user.collections.reload
    expect(current_user.collections.count).to be(1)
    expect(collections.length).to be(1)
    expect(collections.first['name']).to eq('To Keep')
  end
end
