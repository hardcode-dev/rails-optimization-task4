class AddSoundcloudUrlToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :soundcloud_url, :string
  end
end
