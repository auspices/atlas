# frozen_string_literal: true

Fabricator(:collection, from: 'Collection') do
  title { 'A Collection' }
  slug { sequence(:slug) { |i| "collection#{i}" } }
  user { Fabricate(:user) }
end
