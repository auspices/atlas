# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Atlas
  class Application < Rails::Application
    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/app/services
    ]

    config.action_view.field_error_proc = proc { |tag|
      "<span class='HasError'>#{tag}</span>".html_safe
    }

    config.generators do |generate|
      generate.stylesheets false
      generate.javascripts false
      generate.helpers false
    end

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '/api/*', headers: :any, methods: %i[options get put post]
      end
    end
  end
end
