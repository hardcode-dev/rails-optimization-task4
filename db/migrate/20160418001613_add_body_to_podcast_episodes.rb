class AddBodyToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :body, :text
  end
end
