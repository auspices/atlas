# frozen_string_literal: true

require 'rails_helper'

describe 'AddToCollection' do
  let :mutation do
    <<-'GRAPHQL'
      mutation addToCollection($id: ID!, $value: String, $image: ImageInput, $attachment: AttachmentInput $metadata: JSON) {
        addToCollection(input: { id: $id, value: $value, image: $image, attachment: $attachment, metadata: $metadata }) {
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
                ... on Image {
                  id
                  url
                }
                ... on Attachment {
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

  describe 'given an image' do
    let :variables do
      {
        id: collection.id,
        image: {
          url: 'http://example.com/example.jpg'
        }
      }
    end

    fit 'adds the image' do
      pp response['errors']
      pp response['data']
      # expect(content['entity']['__typename']).to eql('Text')
      # expect(content['entity']['body']).to eql('Goodbye worldx')
    end
  end

  describe 'given a value' do
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
  end
end
