# == Schema Information
#
# Table name: search_keywords
#
#  id                 :bigint(8)        not null, primary key
#  created_at         :datetime         not null
#  google_checked_at  :datetime
#  google_difficulty  :integer
#  google_position    :integer
#  google_result_path :string
#  google_volume      :integer
#  keyword            :string
#  updated_at         :datetime         not null
#
class SearchKeyword < ApplicationRecord
  validates :keyword, presence: true
  validates :google_result_path, presence: true
  validates :google_position, presence: true
  validates :google_volume, presence: true
  validates :google_difficulty, presence: true
  validates :google_checked_at, presence: true
  validate :path_format

  private

  def path_format
    errors.add(:google_result_path, "must start with / and be properly formatted") unless google_result_path&.starts_with?("/") && google_result_path&.count("/") == 2
  end
end
