# == Schema Information
#
# Table name: collections
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  description     :string
#  main_image      :string
#  organization_id :integer
#  published       :boolean          default("false")
#  slug            :string
#  social_image    :string
#  title           :string
#  updated_at      :datetime         not null
#  user_id         :integer
#
class Collection < ApplicationRecord
  has_many :articles
  belongs_to :user, optional: true
  belongs_to :organization, optional: true

  validates :user_id, presence: true
  validates :slug, uniqueness: { scope: :user_id }

  def self.find_series(slug, user)
    series = Collection.where(slug: slug, user: user).first
    series || Collection.create(slug: slug, user: user)
  end
end
