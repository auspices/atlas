# frozen_string_literal: true

ruby '2.4.0'
source 'https://rubygems.org'

gem 'active_model_serializers', '~> 0.9.0'
gem 'coffee-rails'
gem 'compass-rails', '~> 2.0.5'
gem 'fastimage', '~> 1.6.3'
gem 'fog-aws'
gem 'friendly_id', '~> 5.0.4'
gem 'jquery-rails'
gem 'kaminari', '~> 0.16.1'
gem 'mime-types', '~> 2.3'
gem 'pg'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 4.2.8'
gem 'sass-rails', '~> 5.0'
gem 'sorcery'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'annotate'
  gem 'foreman'
  gem 'rubocop'
  gem 'spring'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.3.3'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers', require: false
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end

# Temporary
gem 'hashie'
gem 'httparty'
