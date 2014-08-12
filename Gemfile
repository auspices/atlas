ruby '2.1.0'
source 'https://rubygems.org'

gem 'puma'
gem 'pg'
gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'aws-sdk'
gem 'aws-s3'
gem 'kaminari', '~> 0.16.1'
gem 'sorcery'

group :development do
  gem 'spring'
  gem 'annotate'
  gem 'rubocop'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'fabrication'
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end
