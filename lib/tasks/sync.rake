# frozen_string_literal: true

namespace :sync do
  desc 'Sync production database with local'
  task 'production_to_local' do
    Bundler.with_clean_env do
      `heroku pg:backups:capture`
      %x(curl -o latest.dump `heroku pg:backups:url`)
      `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U damonzucconi -d db/atlas_development latest.dump`
      `rm latest.dump`
    end
  end
end
