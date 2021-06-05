unless Rails.env == "test"
  require 'prometheus_exporter/middleware'

  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware

  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Process.start(type: "master")
end