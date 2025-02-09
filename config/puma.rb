# frozen_string_literal: true

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

# Specify the port
port ENV.fetch('PORT', 3000)

# Specify the environment
environment ENV.fetch('RAILS_ENV', 'development')

# Set up the directory for the application
directory ENV.fetch('RAILS_ROOT', Dir.pwd)

on_worker_boot do
  # Worker specific setup for Rails
  ActiveRecord::Base.establish_connection
end
