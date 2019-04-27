# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Atlas
  class Application < Rails::Application
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

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '/graphql', headers: :any, methods: %i[options get put post]
      end
    end
  end
end
