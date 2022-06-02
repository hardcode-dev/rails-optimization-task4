# frozen_string_literal: true

if Rails.env.development? || Rails.env.production? || Rails.env.local_production?
  require "rack-mini-profiler"

  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
  Rack::MiniProfiler.config.show_total_sql_count = true

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
