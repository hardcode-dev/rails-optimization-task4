# == Schema Information
#
# Table name: badges
#
#  id          :bigint(8)        not null, primary key
#  badge_image :string
#  created_at  :datetime         not null
#  description :string           not null
#  slug        :string           not null
#  title       :string           not null
#  updated_at  :datetime         not null
#
class Badge < ApplicationRecord
  mount_uploader :badge_image, BadgeUploader

  has_many :badge_achievements
  has_many :users, through: :badge_achievements

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :badge_image, presence: true

  before_validation :generate_slug
  after_save :bust_path

  def path
    "/badge/#{slug}"
  end

  private

  def generate_slug
    self.slug = title.to_s.downcase.tr(" ", "-").gsub(/[^\w-]/, "").tr("_", "")
  end

  def bust_path
    cache_buster = CacheBuster.new
    cache_buster.bust path
    cache_buster.bust path + "?i=i"
  end
end
