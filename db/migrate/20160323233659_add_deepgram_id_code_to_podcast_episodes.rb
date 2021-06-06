class AddDeepgramIdCodeToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :deepgram_id_code, :string
  end
end
