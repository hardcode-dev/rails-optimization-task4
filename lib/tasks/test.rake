namespace :test do
  desc "run"
  task run: :environment do
    cmd = "rake parallel:spec[3,^spec/models]"
    puts "Running rspec via `#{cmd}`"

    start = Time.now
    system(cmd)
    finish = Time.now

    puts "SENDING METRIC TO INFLUXDB"
    TestMetrics.write(user: "permidon", run_time_seconds: (finish - start).to_i)
  end
end
