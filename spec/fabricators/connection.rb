# frozen_string_literal: true

Fabricator(:connection, from: 'Connection') do
  user { Fabricate(:user) }
  collection { Fabricate(:collection) }
  image { Fabricate(:image) }
end
