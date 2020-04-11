namespace :test do
  desc "run"
  task run: :environment do
    puts "Running rspec via `rake test:run`"
    threads_count = ENV['TEST_ENV_NUMBER'] || 1

    start = Time.now
    # system 'rspec'
    system "rake parallel:spec[#{threads_count}]"
    finish = Time.now

    puts 'SENDING METRIC TO INFLUXDB'
    TestMetrics.write(user: ENV['USER'] || 'unknown_user', run_time_seconds: (finish - start).to_i)
  end
end
