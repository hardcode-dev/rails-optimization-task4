namespace :test do
  desc "Run rspec"
  task run: :environment do
    abort "InfluxDB not running!" unless influx_running?

    command = TTY::Command.new(printer: :quiet, color: true)
    puts "Running rspec via `rspec`"

    start = Time.now
    begin
      command.run("rspec")
      # command.run("bundle exec rake 'parallel:spec[3]'")
    rescue TTY::Command::ExitError
      puts "TEST FAILED SAFELY"
    end
    finish = Time.now

    puts "Sending metric to InfluxDB"
    TestDurationMetric.write(user: 'bav', run_time_seconds: (finish - start).to_i)
  end

  def influx_running?
    influx_endpoint = "http://localhost:8086/"
    puts "Check InfluxDB on #{influx_endpoint}..."

    command = TTY::Command.new(printer: :null)
    command.run!("curl #{influx_endpoint}/ping").success?
  end
end
