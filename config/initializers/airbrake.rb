Airbrake.configure do |c|
  c.ignore_environments = %w[test development local_production]
  c.project_id = ApplicationConfig["AIRBRAKE_PROJECT_ID"]
  c.project_key = ApplicationConfig["AIRBRAKE_API_KEY"]

  c.root_directory = Rails.root

  c.logger = Rails.logger

  c.environment = Rails.env

  c.blacklist_keys = [/password/i]
end

Airbrake.add_filter do |notice|
  notice.ignore! if notice[:errors].any? { |error| error[:type] == "Pundit::NotAuthorizedError" }
end
