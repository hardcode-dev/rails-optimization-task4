# rubocop:disable Metrics/BlockLength

Rails.application.configure do
  config.webpacker.check_yarn_integrity = false

  # cache_classes: true
  # eager_load: true
  # perform_caching: true
  # assets_debug: false
  # assets_compile: false

  config.cache_classes = true
  config.eager_load = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store
  config.assets.debug = false
  config.assets.compile = true
  config.consider_all_requests_local = false
  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

  config.assets.digest = true
end

# rubocop:enable Metrics/BlockLength
