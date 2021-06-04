# frozen_string_literal: true

class EnvironmentConfig < AppConfig
  attr_config(
    app_domain: 'dev.to',
    cache_classes: true,
    eager_load: true,    
    perform_caching: true,
    assets_debug: false,
    assets_compile: false,
    assets_digest: true
  )
end

