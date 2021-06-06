class AddProcessedHtmlToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :processed_html, :text
  end
end
