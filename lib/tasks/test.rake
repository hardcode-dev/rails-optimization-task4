namespace :test do
  desc 'Run rspec'
  task run: :environment do
    abort 'INFLUXDB NOT RUNNING' unless influxdb_running?

    command = TTY::Command.new(printer: :quiet, color: true)
    puts 'Running RSpec via `rspec`'
    start_time = Time.now
    begin
      # command.run('rspec')
      command.run("bundle exec rake 'parallel:spec[6]'")
    rescue TTY::Command::ExitError
      puts 'TEST FAILED SAFELY'
    end
    total_time = (Time.now - start_time).to_i

    puts 'Sending metric to InfluxDB'
    TestDurationMetric.write(user: 'hworoshch', run_time_seconds: total_time)
    puts "Total time: #{total_time} s."
  end

  def influxdb_running?
    influx_endpoint = 'http://localhost:8086'
    puts "Check InfluxDB on #{influx_endpoint}..."

    command = TTY::Command.new(printer: :null)
    command.run("curl #{influx_endpoint}/ping").success?
  end
end
