# frozen_string_literal: true

ruby '2.6.3'
source 'https://rubygems.org'

gem 'acts_as_list'
gem 'addressable'
gem 'aws-sdk-s3', '~> 1.36', '>= 1.36.1'
gem 'batch-loader'
gem 'fastimage', '~> 2.1', '>= 2.1.5'
gem 'friendly_id', '~> 5.1'
gem 'graphql'
gem 'graphql-errors'
gem 'jwt'
gem 'kaminari', '~> 1.2'
gem 'mime-types', '~> 3.2', '>= 3.2.2'
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5'
gem 'sorcery'
gem 'twilio-ruby'

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'graphiql-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 4.0'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers', require: false
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end
