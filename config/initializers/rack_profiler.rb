# frozen_string_literal: true

Rails.application.config.to_prepare do
  Rack::MiniProfiler.profile_method(StoriesController, :index) do |_a|
    'Executing index stories'
  end
end
