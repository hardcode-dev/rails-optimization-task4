namespace :test do
  desc "run"
  task run: :environment do
    abort 'InfluxDB not running!' unless influx_running?

    cmd = 'rspec'
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
    TestDurationMetric.write(user: 'IgorArkhipov', run_time_seconds: (finish - start).to_i)
  end

  def influx_running?
    influx_endpoint = ENV['INFLUX_ENDPOINT'] || 'http://localhost:8086'
    puts "Check InfluxDB on #{influx_endpoint}..."

    command = TTY::Command.new(printer: :null)
    command.run!("curl #{influx_endpoint}/ping").success?
  end
end
