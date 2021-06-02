class CommentObserver < ApplicationObserver
  def after_save(comment)
    return if %w[development local_production].include?(Rails.env)

    warned_user_ping(comment)
  rescue StandardError
    puts "error"
  end
end
