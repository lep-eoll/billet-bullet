namespace :db do
  desc "Loads a pg dump to local db"
  task :load_dump, [:dumpfile] => :environment do |t, args|
    file = args[:dumpfile] || 'tmp/latest.dump'
    db_config = Rails.application.config.database_configuration[Rails.env]
    if db_config['password'].present?
      puts "password is '#{db_config['password']}' "
    end

    # from https://devcenter.heroku.com/articles/heroku-postgres-import-export
    # pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump
    command = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{db_config['database']} #{file}"

    puts 'running:'
    puts command
    puts `#{command}`
  end
end

