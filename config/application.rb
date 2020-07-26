# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Atlas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    config.assets.enabled = false

    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/app/services
    ]

    config.generators do |generate|
      generate.stylesheets false
      generate.javascripts false
      generate.helpers false
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/graphql', headers: :any, methods: %i[options get put post]
        resource '/graph', headers: :any, methods: %i[options get put post]
        resource '/graph/*', headers: :any, methods: %i[options get put post]
      end
    end

    config.middleware.use BatchLoader::Middleware
  end
end
