# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
ENV["REGISTRATION_SECRET"] ||= 'secret'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'fabrication'
require 'shoulda/matchers'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
  config.include Sorcery::TestHelpers::Rails::Integration, type: :feature
  config.include GraphQLHelpers
  config.extend Macros
end
