# frozen_string_literal: true

Fabricator(:user, from: 'User') do
  username { sequence(:username) { |i| "user#{i}" } }
  slug { sequence(:slug) { |i| "user#{i}" } }
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password { 'secret' }
end
