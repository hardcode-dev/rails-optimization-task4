class AddOrderKeyToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :order_key, :string
  end
end
