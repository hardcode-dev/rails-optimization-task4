require 'tty-command'
require 'benchmark'

namespace :devto do
  task test: :environment do
    git_cmd = TTY::Command.new(printer: :null)
    user = git_cmd.run('git config user.name').out.chomp!
    rspec_cmd = TTY::Command.new(printer: :progress)
    seconds = Benchmark.realtime do
      rspec_cmd.run({'RAILS_ENV' => 'TEST'}, 'rspec spec/decorators/comment_decorator_spec.rb')
    end
    puts 'Finished!'
    {
      user: user,
      seconds: seconds
    }
  end
end
