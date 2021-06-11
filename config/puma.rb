workers Integer(ENV["WEB_CONCURRENCY"] || 2)
threads_count = Integer(ENV["MAX_THREADS"] || 5)
threads threads_count, threads_count

worker_timeout 15
worker_shutdown_timeout 8

preload_app!

rackup DefaultRackup
port ENV["PORT"] || 3000
environment ENV["RACK_ENV"] || "development"

on_worker_boot do
  puts "CONFIG SAYS: config.assets.compile #{Rails.application.config.assets.compile}"
  puts "CONFIG SAYS: config.assets.digest #{Rails.application.config.assets.digest}"
  
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

after_worker_boot do
  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Puma.start
  # For watch the following metrics
  # Gauge	puma_booted_workers_total	Number of puma workers booted
  # Gauge	puma_running_threads_total	Number of puma threads currently running  
end


after_worker_boot do

  require 'prometheus_exporter/instrumentation'
  #PrometheusExporter::Instrumentation::Process.start(type: "web:#{Process.pid}")
  PrometheusExporter::Instrumentation::Process.start(type: "web")

  # For watch the following metrics
  #Gauge	heap_free_slots	Free ruby heap slots
  #Gauge	heap_live_slots	Used ruby heap slots
end