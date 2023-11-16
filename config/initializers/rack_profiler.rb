require "rack-mini-profiler"

Rack::MiniProfilerRails.initialize!(Rails.application)
Rack::MiniProfiler.config.authorization_mode = :allow_all
