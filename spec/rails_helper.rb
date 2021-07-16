ENV["RAILS_ENV"] = "test"

require "spec_helper"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Add additional requires below this line. Rails is not loaded until this point!

require "algolia/webmock"
require "pundit/matchers"
require "pundit/rspec"
require "webmock/rspec"
require "test_prof/recipes/rspec/before_all"
require "test_prof/recipes/rspec/let_it_be"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/features/shared_examples/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/models/shared_examples/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Disable internet connection with Webmock
WebMock.disable_net_connect!(allow_localhost: true)

################################################################################
# Отправка метрики в InfluxDB
#
# Набросок на стадии концепта, нуждается в более правильной компоновке.
#

INFLUXDB_USER = "me".freeze

def with_metric?
  # Для того, чтобы не создавать не относящийся к задаче код,
  # я не стал добавлять проверку на то, что прогоняется весь сьют, ее можно
  # реализовать, пересчитав кодичество файлов в путях, указанных в
  # Rspec.configuration в #default_path и #pattern, и сравнив их со списком
  # прогоняемых файлов, который также есть в конфигурации в #files_to_run.

  # Включить отправку метрик можно с помощью переменной окружения
  ENV["WITH_METRIC"].present? && %w[0 false].exclude?(ENV["WITH_METRIC"].downcase)
end

def start_metric
  @@metric_started_at = Time.current
end

def send_metric
  value = (Time.current - @@metric_started_at).to_i
  puts "[METRIC] Suite execution time: #{value} s"
  puts "[METRIC] Sending to Influxdb..."
  result = TestDurationMetric.write(user: INFLUXDB_USER, run_time: value)
  puts "[METRIC] #{result ? 'Success' : 'Error'}"
end

################################################################################

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include ApplicationHelper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include FactoryBot::Syntax::Methods
  config.include OmniauthMacros

  config.before do
    ActiveRecord::Base.observers.disable :all # <-- Turn 'em all off!
  end

  # Only turn on VCR if :vcr is included metadata keys
  config.around do |ex|
    if ex.metadata.key?(:vcr)
      ex.run
    else
      VCR.turned_off { ex.run }
    end
  end

  if with_metric?
    config.before(:suite) { start_metric }
    config.after(:suite) { send_metric }
  end

  # Allow testing with Stripe's test server. BECAREFUL
  if config.filter_manager.inclusions.rules.include?(:live)
    WebMock.allow_net_connect!
    StripeMock.toggle_live(true)
    puts "Running **live** tests against Stripe..."
  end

  config.before do
    stub_request(:any, /res.cloudinary.com/).to_rack("dsdsdsds")

    stub_request(:post, /api.fastly.com/).
      to_return(status: 200, body: "", headers: {})

    stub_request(:post, /api.bufferapp.com/).
      to_return(status: 200, body: { fake_text: "so fake" }.to_json, headers: {})

    # for twitter image cdn
    stub_request(:get, /twimg.com/).
      to_return(status: 200, body: "", headers: {})

    stub_request(:any, /api.mailchimp.com/).
      to_return(status: 200, body: "", headers: {})
  end

  OmniAuth.config.test_mode = true

  config.infer_spec_type_from_file_location!

  config.example_status_persistence_file_path = "tmp/examples.txt"
end
