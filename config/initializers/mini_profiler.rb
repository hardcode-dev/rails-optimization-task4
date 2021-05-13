if Rails.env.development?
  # https://www.rubydoc.info/gems/rack-mini-profiler
  Rack::MiniProfiler.config.position = 'bottom-right'
  Rack::MiniProfiler.config.start_hidden = false
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
