namespace :test do
  desc "run"
  task run: :environment do
    cmd = "rspec spec/models"
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
    TestMetrics.write(user: 'permidon', run_time_seconds: (finish - start).to_i)
  end
end
