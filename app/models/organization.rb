# == Schema Information
#
# Table name: organizations
#
#  id                 :integer          not null, primary key
#  address            :string
#  approved           :boolean          default("false")
#  bg_color_hex       :string
#  city               :string
#  company_size       :string
#  country            :string
#  created_at         :datetime         not null
#  cta_body_markdown  :text
#  cta_button_text    :string
#  cta_button_url     :string
#  cta_processed_html :text
#  email              :string
#  github_username    :string
#  jobs_email         :string
#  jobs_url           :string
#  last_article_at    :datetime         default("2017-01-01 05:00:00")
#  location           :string
#  name               :string
#  nav_image          :string
#  old_old_slug       :string
#  old_slug           :string
#  profile_image      :string
#  profile_updated_at :datetime         default("2017-01-01 05:00:00")
#  proof              :text
#  secret             :string
#  slug               :string
#  state              :string
#  story              :string
#  summary            :text
#  tag_line           :string
#  tech_stack         :string
#  text_color_hex     :string
#  twitter_username   :string
#  updated_at         :datetime         not null
#  url                :string
#  zip_code           :string
#
class Organization < ApplicationRecord
  include CloudinaryHelper

  acts_as_followable

  has_many :job_listings
  has_many :users
  has_many :api_secrets, through: :users
  has_many :articles
  has_many :collections
  has_many :display_ads
  has_many :notifications

  validates :name, :summary, :url, :profile_image, presence: true
  validates :name,
            length: { maximum: 50 }
  validates :summary,
            length: { maximum: 250 }
  validates :tag_line,
            length: { maximum: 60 }
  validates :jobs_email, email: true, allow_blank: true
  validates :text_color_hex, format: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, allow_blank: true
  validates :bg_color_hex, format: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, allow_blank: true
  validates :slug,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9\-_]+\Z/ },
            length: { in: 2..18 },
            exclusion: { in: ReservedWords.all,
                         message: "%{value} is reserved." }
  validates :url, url: { allow_blank: true, no_local: true, schemes: %w[https http] }
  validates :secret, uniqueness: { allow_blank: true }
  validates :location, :email, :company_size, length: { maximum: 64 }
  validates :company_size, format: { with: /\A\d+\z/,
                                     message: "Integer only. No sign allowed.",
                                     allow_blank: true }
  validates :tech_stack, :story, length: { maximum: 640 }
  validates :cta_button_url,
    url: { allow_blank: true, no_local: true, schemes: %w[https http] }
  validates :cta_button_text, length: { maximum: 20 }
  validates :cta_body_markdown, length: { maximum: 256 }
  before_save :remove_at_from_usernames
  after_save  :bust_cache
  before_save :generate_secret
  before_validation :downcase_slug
  before_validation :check_for_slug_change
  before_validation :evaluate_markdown

  validate :unique_slug_including_users

  mount_uploader :profile_image, ProfileImageUploader
  mount_uploader :nav_image, ProfileImageUploader

  alias_attribute :username, :slug
  alias_attribute :old_username, :old_slug
  alias_attribute :old_old_username, :old_old_slug
  alias_attribute :website_url, :url

  def check_for_slug_change
    return unless slug_changed?

    self.old_old_slug = old_slug
    self.old_slug = slug_was
    articles.find_each { |a| a.update(path: a.path.gsub(slug_was, slug)) }
  end

  def path
    "/#{slug}"
  end

  def generate_secret
    self.secret = generated_random_secret if secret.blank?
  end

  def generated_random_secret
    SecureRandom.hex(50)
  end

  def approved_and_filled_out_cta?
    cta_processed_html?
  end

  def profile_image_90
    ProfileImage.new(self).get(90)
  end

  private

  def evaluate_markdown
    self.cta_processed_html = MarkdownParser.new(cta_body_markdown).evaluate_limited_markdown
  end

  def remove_at_from_usernames
    self.twitter_username = twitter_username.gsub("@", "") if twitter_username
    self.github_username = github_username.gsub("@", "") if github_username
  end

  def downcase_slug
    self.slug = slug.downcase
  end

  def bust_cache
    cache_buster = CacheBuster.new
    cache_buster.bust("/#{slug}")
    begin
      articles.find_each do |article|
        cache_buster.bust(article.path)
      end
    rescue StandardError
      puts "Tag issue"
    end
  end
  handle_asynchronously :bust_cache

  def unique_slug_including_users
    errors.add(:slug, "is taken.") if User.find_by_username(slug)
  end
end
