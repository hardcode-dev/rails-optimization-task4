# rubocop:disable Metrics/BlockLength
#
def yarn_integrity_enabled?
  ENV.fetch("YARN_INTEGRITY_ENABLED", "true") == "true"
end

Rails.application.configure do
  config.webpacker.check_yarn_integrity = false
  config.cache_classes = true
  config.assets_compile = false
  config.eager_load = true
  config.consider_all_requests_local = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = false
  config.assets.digest = false
  config.assets.quiet = true
  config.assets.raise_runtime_errors = true
  config.action_mailer.perform_caching = true
  config.app_domain = "localhost:3000"
  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: config.app_domain }
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: "587",
    enable_starttls_auto: true,
    user_name: '<%= ENV["DEVELOPMENT_EMAIL_USERNAME"] %>',
    password: '<%= ENV["DEVELOPMENT_EMAIL_PASSWORD"] %>',
    authentication: :plain,
    domain: "localhost:3000"
  }
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
  config.public_file_server.enabled = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  send_logs_to_timber = ENV["SEND_LOGS_TO_TIMBER"] || "false" # <---- set to false to stop sending dev logs to Timber.io
  log_device = send_logs_to_timber == "true" ? Timber::LogDevices::HTTP.new(ENV["TIMBER"]) : STDOUT
  logger = Timber::Logger.new(log_device)
  logger.level = config.log_level
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.after_initialize do
    Bullet.enable = true
    Bullet.console = true
  end
end

# rubocop:enable Metrics/BlockLength
