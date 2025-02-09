# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Atlas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.autoload_paths += %W[
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

    # For Rails 7.1: Configure your mailer to use Active Job
    config.action_mailer.deliver_later_queue_name = :mailers
    config.action_mailer.perform_deliveries = true

    # For Rails 7.1: Set Time Zone
    config.time_zone = 'UTC'

    # Use credentials for secret key base
    config.secret_key_base = credentials.secret_key_base
  end
end
