require 'tty-command'
require 'benchmark'

namespace :devto do
  task test: :environment do
    git_cmd = TTY::Command.new(printer: :null)
    user = git_cmd.run('git config user.name').out.chomp!
    rspec_cmd = TTY::Command.new(printer: :pretty)
    seconds = Benchmark.realtime do
      rspec_cmd.run({'RAILS_ENV' => 'TEST'}, "rspec --exclude-pattern '**/features/**/*_spec.rb'")
    end
    puts "Finished in #{seconds}"

    influx_data = {
      name: 'rspec_metrics',
      tags: {user: user},
      fields: {seconds: seconds.to_i}
    }
    InfluxClient.write(influx_data)
  end
end
