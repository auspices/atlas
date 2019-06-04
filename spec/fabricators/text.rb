# frozen_string_literal: true

Fabricator(:text, from: 'Text') do
  user { Fabricate(:user) }
  body { 'Hello world '}
end
