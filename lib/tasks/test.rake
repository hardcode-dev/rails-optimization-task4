namespace :test do
  desc "Run rspec"
  task  run: :environment do
    abort unless influx_running?

    command = TTY::Command.new(printer: :quiet, color: true)
    puts "Running rspec via `rspec`"

    start = Time.now
    begin
      # command.run("SAMPLE=10 rspec")
      command.run("rspec ./spec/controllers/internal_users_controller_spec.rb")
    rescue
      puts "TEST FAILD SAFELY"
    end
    finish = Time.now

    puts "Sending metric to InfluxDB"
    TestDurationMetric.write(user: 'test_user', run_time_seconds: (finish - start).to_i)
  end

  def influx_running?
    influx_endpoint = "http://influxdb:8086/"
    puts "Check InfluxDB on #{influx_endpoint}..."

    command = TTY::Command.new(printer: :null)
    command.run!("curl #{influx_endpoint}/ping").success?
  end
end
