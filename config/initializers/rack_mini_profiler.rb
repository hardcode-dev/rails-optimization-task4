# frozen_string_literal: true

require "rack-mini-profiler"

# The initializer was required late, so initialize it manually.
Rack::MiniProfilerRails.initialize!(Rails.application)

Rails.application.middleware.delete(Rack::MiniProfiler)
Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
