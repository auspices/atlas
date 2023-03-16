# frozen_string_literal: true

ruby '3.2.0'
source 'https://rubygems.org'

gem 'acts_as_list'
gem 'addressable'
gem 'airbrake'
gem 'aws-sdk-s3', '~> 1.36', '>= 1.36.1'
gem 'batch-loader'
gem 'fastimage', '~> 2.1', '>= 2.1.5'
gem 'friendly_id', '~> 5.1'
gem 'graphiql-rails'
gem 'graphql'
gem 'jwt'
gem 'kaminari', '~> 1.1', '>= 1.1.1'
gem 'mime-types', '~> 3.2', '>= 3.2.2'
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 6'
gem 'sorcery'
gem 'stripe'
gem 'twilio-ruby'

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 6.0'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers', require: false
  gem 'stripe-ruby-mock', '3.1.0.rc3', require: 'stripe_mock'
  gem 'webmock'
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end
