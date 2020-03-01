# == Schema Information
#
# Table name: podcasts
#
#  id                  :integer          not null, primary key
#  android_url         :string
#  created_at          :datetime         not null
#  description         :text
#  feed_url            :string
#  image               :string
#  itunes_url          :string
#  main_color_hex      :string
#  overcast_url        :string
#  pattern_image       :string
#  slug                :string
#  soundcloud_url      :string
#  status_notice       :text             default("")
#  title               :string
#  twitter_username    :string
#  unique_website_url? :boolean          default("true")
#  updated_at          :datetime         not null
#  website_url         :string
#
class Podcast < ApplicationRecord
  has_many :podcast_episodes

  mount_uploader :image, ProfileImageUploader
  mount_uploader :pattern_image, ProfileImageUploader

  after_save :bust_cache
  after_create :pull_all_episodes

  def path
    slug
  end

  def profile_image_url
    image_url
  end

  def name
    title
  end

  private

  def bust_cache
    CacheBuster.new.bust("/" + path)
  end

  def pull_all_episodes
    PodcastFeed.new.get_episodes(self)
  end
  handle_asynchronously :pull_all_episodes
end
