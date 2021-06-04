class EnvironmentConfigurator
  def self.call
    Rails.application.configure do
      settings = EnvironmentConfig.new

      # Code is not reloaded between requests.
      config.cache_classes = settings.cache_classes

      # Eager load code on boot. This eager loads most of Rails and
      # your application in memory, allowing both threaded web servers
      # and those relying on copy on write to perform better.
      # Rake tasks automatically ignore this option for performance.
      config.eager_load = settings.eager_load
      config.app_domain = settings.app_domain

      # Enable/disable caching. By default caching is disabled.
      if settings.perform_caching
      #if Rails.root.join("tmp/caching-dev.txt").exist?
        config.action_controller.perform_caching = true

        config.cache_store = :memory_store
        config.public_file_server.headers = {
          "Cache-Control" => "public, max-age=172800"
        }
      else
        config.action_controller.perform_caching = false

        config.cache_store = :null_store
      end
      config.assets.debug = settings.assets_debug
      config.assets.compile = settings.assets_compile
      config.assets.digest = settings.assets_digest

    end
  end
end
