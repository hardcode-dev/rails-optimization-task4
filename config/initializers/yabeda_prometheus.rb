# frozen_string_literal: true

unless %w[development test].include?(Rails.env)
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
