# == Schema Information
#
# Table name: api_secrets
#
#  id          :bigint(8)        not null, primary key
#  created_at  :datetime         not null
#  description :string           not null
#  secret      :string
#  updated_at  :datetime         not null
#  user_id     :integer
#
class ApiSecret < ApplicationRecord
  has_secure_token :secret
  belongs_to :user
  validates :description, presence: true
end
