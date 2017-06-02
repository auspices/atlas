# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Connector do
  let(:user) { Fabricate(:user) }
  let(:collection) { Fabricate(:collection) }
  let(:image) { Fabricate(:image) }

  it 'connects the Image to the Collection with a valid Connection' do
    connection = Connector.build(user, collection, image)
    expect(connection).to be_valid
    expect(connection.user).to eq(user)
    expect(connection.collection).to eq(collection)
    expect(connection.image).to eq(image)
  end
end
