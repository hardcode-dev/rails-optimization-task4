ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "warning"
Gem.path.each do |path|
  Warning.ignore(//, path)
end

require "bundler/setup" # Set up gems listed in the Gemfile.
