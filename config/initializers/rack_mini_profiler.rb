# frozen_string_literal: true

if Rails.env.development? || Rails.env.localproduction?
  require "rack-mini-profiler"

  # The initializer was required late, so initialize it manually.
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.authorization_mode = :allow_all
end
