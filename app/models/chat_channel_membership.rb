# == Schema Information
#
# Table name: chat_channel_memberships
#
#  id                             :bigint(8)        not null, primary key
#  chat_channel_id                :bigint(8)        not null
#  created_at                     :datetime         not null
#  has_unopened_messages          :boolean          default("false")
#  last_opened_at                 :datetime         default("2017-01-01 05:00:00")
#  role                           :string           default("member")
#  show_global_badge_notification :boolean          default("true")
#  status                         :string           default("active")
#  updated_at                     :datetime         not null
#  user_id                        :bigint(8)        not null
#
# Foreign Keys
#
#  fk_rails_...  (chat_channel_id => chat_channels.id)
#  fk_rails_...  (user_id => users.id)
#
class ChatChannelMembership < ApplicationRecord
  belongs_to :chat_channel
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: :chat_channel_id }
  validates :chat_channel_id, presence: true, uniqueness: { scope: :user_id }
  validates :status, inclusion: { in: %w[active inactive pending rejected left_channel] }
  validates :role, inclusion: { in: %w[member mod] }
  validate  :permission

  private

  def permission
    errors.add(:user_id, "is not allowed in chat") if chat_channel.direct? && chat_channel.slug.split("/").exclude?(user.username)
    # To be possibly implemented in future
    # if chat_channel.users.size > 128
    #   errors.add(:base, "too many members in channel")
    # end
  end
end
