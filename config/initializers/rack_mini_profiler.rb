# frozen_string_literal: true

if %w[development lp].include?(Rails.env)
  require "rack-mini-profiler"

  # The initializer was required late, so initialize it manually.
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.authorization_mode = :allow_all if Rails.env.lp?
end
