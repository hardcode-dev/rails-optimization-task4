class AddQuoteToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :quote, :text
  end
end
