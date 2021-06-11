# frozen_string_literal: true

unless Rails.env.test?
  require "rack-mini-profiler"
  Rack::MiniProfiler.config.authorization_mode = if Rails.env.development?
    :allow_all
  else
    :allow_authorized
  end
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
