# frozen_string_literal: true

namespace :sync do
  desc 'Sync production database with local'
  task 'production_to_local' do
    Bundler.with_clean_env do
      `heroku pg:backups:capture --app auspices-atlas-production`
      %x(curl -o latest.dump `heroku pg:backups:url --app auspices-atlas-production`)
      `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U dzucconi -d db/atlas_development latest.dump`
      `rm latest.dump`
    end
  end
end
