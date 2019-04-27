# frozen_string_literal: true

ruby '2.6.3'
source 'https://rubygems.org'

gem 'fastimage', '~> 1.6.3'
gem 'fog-aws'
gem 'friendly_id', '~> 5.0.4'
gem 'graphql'
gem 'graphql-batch'
gem 'graphql-errors'
gem 'jwt'
gem 'kaminari', '~> 0.16.1'
gem 'mime-types', '~> 2.3'
gem 'pg', '~> 0.11'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5'
gem 'sorcery'

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'graphiql-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers', require: false
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end
