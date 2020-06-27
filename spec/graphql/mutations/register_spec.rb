# frozen_string_literal: true

require 'rails_helper'

describe 'Register' do
  mock_stripe

  let :mutation do
    <<-'GRAPHQL'
      mutation register(
        $secret: String!
        $username: String!
        $password: String!
        $passwordConfirmation: String!
        $email: String!
      ) {
        register(
          input: {
            secret: $secret
            username: $username
            password: $password
            passwordConfirmation: $passwordConfirmation
            email: $email
          }
        ) {
          jwt
          user {
            id
            slug
          }
        }
      }
    GRAPHQL
  end

  let :response do
    execute mutation, variables: variables
  end

  describe 'valid input' do
    let :variables do
      {
        secret: 'secret',
        username: 'test',
        password: 'foobar',
        passwordConfirmation: 'foobar',
        email: 'test@example.com',
      }
    end

    it 'registers the user' do
      expect { response['data']['register'] }.to change { User.count }.by(1)
      user = User.last
      expect(user.username).to eq('test')
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'invalid input' do
    # TODO
  end
end
