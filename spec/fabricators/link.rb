# frozen_string_literal: true

Fabricator(:link, from: 'Link') do
  url { 'https://example.com' }
  user { Fabricate(:user) }
end
