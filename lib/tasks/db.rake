namespace :db do

  def latest_db_backup
    `ls -lt tmp/*.dump`.split("\n").first.split(' ').last
  end

  desc "creates backup on prod, downloads it and loads locally"
  task :fresh_prod do
    Rake::Task["db:create_backup"].execute
    Rake::Task["db:download_latest_backup"].execute
    Rake::Task["db:load_backup"].execute
  end

  desc "Creates a remote heroku backup"
  task :create_backup do
    ap 'running \'heroku pg:backups capture\''
    ap `heroku pg:backups capture`
  end

  task :download_latest_backup do
    require 'date'
    ap 'grabbing most recent backup from heroku..'
    tmp = `heroku pg:backups`.split("\n")[3].split
    last_backup_date = DateTime.strptime("#{tmp[5]} #{tmp[6]}", '%Y-%m-%d %H:%M:%S')
    backup_url = `heroku pg:backups public-url #{tmp[0]}`.chomp
    ap `curl -o tmp/#{last_backup_date.strftime('%Y%M%d-%H%M')}.dump '#{backup_url}'`
    ap "latest backup saved to tmp/#{last_backup_date.strftime('%Y%M%d-%H%M')}.dump "
  end

  desc "Loads a pg dump to local db"
  task :load_backup, [:dumpfile] => :environment do |t, args|
    file = args[:dumpfile] || latest_db_backup
    ap "restoring backup: #{file}"
    db_config = Rails.application.config.database_configuration[Rails.env]
    if db_config['password'].present?
      puts "password is '#{db_config['password']}' "
    end

    # from https://devcenter.heroku.com/articles/heroku-postgres-import-export
    # pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump
    command = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{db_config['database']} #{file}"

    puts "running: '#{command}'"
    puts `#{command}`
  end
end

