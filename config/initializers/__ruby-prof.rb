# frozen_string_literal: true

if ENV["RUBY_PROF"].present?
  require "ruby-prof"

  Rails.application.config.middleware.use(Rack::RubyProf, path: "report/ruby-prof")
end
