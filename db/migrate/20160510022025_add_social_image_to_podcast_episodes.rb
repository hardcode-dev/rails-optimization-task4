class AddSocialImageToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :social_image, :string
  end
end
