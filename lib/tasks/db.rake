namespace :test do
  desc "run"
  task run: :environment do
    abort 'Influx not running' unless infux_running?
    cmd = "rspec"
    puts "Running rspec via `#{cmd}`"
    command = TTY::Command.new(printer: :quiet, color: true)

    start = Time.now
    begin
      command.run(cmd)
    rescue TTY::Command::ExitError
      puts 'TEST FAILED SAFELY'
    end
    finish = Time.now

    puts 'SENDING METRIC TO INFLUXDB'
    TestDurationMetrics.write(user: 'dima', run_time_seconds: (finish - start).to_i)
  end

  def infux_running?
    endpoint = 'http://localhost:8086'
    puts "Check influx on #{endpoint}"

    command = TTY::Command.new(printer: :null)
    command.run("curl #{endpoint}/ping").success?
  end
end

# rubocop:disable Metrics/LineLength
# namespace :db do
#
#   desc "Copy production database to local"
#
#   task :copy_production => :environment do
#     puts "FIRING UP!"
#     # Download latest dump
#     system("echo hey")
#     system("heroku pg:backups --remote heroku capture")
#     system("curl -o latest.dump `heroku pg:backups --remote heroku public-url`")
#
#
#     # get user and database name
#     # config   = Rails.configuration.database_configuration["development"]
#     # database = config["database"]
#     # user = config["username"]
#     #
#     # # import
#     # system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{database} #{Rails.root}/tmp/latest.dump")
#   end
#
# end
#
#
# heroku pg:backups --remote heroku capture
# curl -o latest.dump `heroku pg:backups --remote heroku public-url`
# rake db:reset
# pg_restore --verbose --no-acl --no-owner -t articles -t users -t podcasts -t podcast_episodes -t sponsors -t identities -t organizations -h localhost -d PracticalDeveloper_development latest.dump
# rake db:migrate
# pg_restore --verbose --clean --no-acl --no-owner -t articles -t users -t podcasts -t podcast_episodes -t sponsors -t identities -t organizations -h localhost -d PracticalDeveloper_development latest.dump
# rubocop:enable Metrics/LineLength
