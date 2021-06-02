class OrganizationObserver < ActiveRecord::Observer
  def after_create(organization)
    return if %w[development local_production].include?(Rails.env)

    SlackBot.delay.ping(
      "New Org Created: #{organization.name}\nhttps://dev.to/#{organization.username}",
      channel: "orgactivity",
      username: "org_bot",
      icon_emoji: ":office:",
    )
  rescue StandardError
    puts "error"
  end
end
