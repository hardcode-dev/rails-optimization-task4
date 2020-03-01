# == Schema Information
#
# Table name: push_notification_subscriptions
#
#  id                :bigint(8)        not null, primary key
#  auth_key          :string
#  created_at        :datetime         not null
#  endpoint          :string
#  notification_type :string
#  p256dh_key        :string
#  updated_at        :datetime         not null
#  user_id           :bigint(8)        not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class PushNotificationSubscription < ApplicationRecord
  validates :endpoint, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :p256dh_key, presence: true, uniqueness: true
  validates :auth_key, presence: true, uniqueness: true
  validates :notification_type, presence: true, inclusion: { in: %w[browser] }
  belongs_to :user
end
