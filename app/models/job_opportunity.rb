# == Schema Information
#
# Table name: job_opportunities
#
#  id                    :bigint(8)        not null, primary key
#  created_at            :datetime         not null
#  experience_level      :string
#  location_city         :string
#  location_country_code :string
#  location_given        :string
#  location_lat          :decimal(10, 6)
#  location_long         :decimal(10, 6)
#  location_postal_code  :string
#  permanency            :string
#  remoteness            :string
#  time_commitment       :string
#  updated_at            :datetime         not null
#
class JobOpportunity < ApplicationRecord
  has_many :articles
  validates :remoteness,
    inclusion: { in: %w[on_premise fully_remote remote_optional on_premise_flexible] }
  def remoteness_in_words
    phrases = {
      "on_premise" => "In Office",
      "fully_remote" => "Fully Remote",
      "remote_optional" => "Remote Optional",
      "on_premise_flexible" => "Mostly in Office but Flexible"
    }
    phrases[remoteness]
  end
end
