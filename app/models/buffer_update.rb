# == Schema Information
#
# Table name: buffer_updates
#
#  id                     :bigint(8)        not null, primary key
#  article_id             :integer          not null
#  body_text              :text
#  buffer_id_code         :string
#  buffer_profile_id_code :string
#  buffer_response        :text             default("--- {}\n")
#  created_at             :datetime         not null
#  social_service_name    :string
#  tag_id                 :integer
#  updated_at             :datetime         not null
#
class BufferUpdate < ApplicationRecord
  belongs_to :article

  validate :validate_body_text_recent_uniqueness

  def self.buff!(article_id, text, buffer_profile_id_code, social_service_name = "twitter", tag_id = nil)
    buffer_response = send_to_buffer(text, buffer_profile_id_code)
    create(
      article_id: article_id,
      tag_id: tag_id,
      body_text: text,
      buffer_profile_id_code: buffer_profile_id_code,
      social_service_name: social_service_name,
      buffer_response: buffer_response,
    )
  end

  def self.send_to_buffer(text, buffer_profile_id_code)
    client = Buffer::Client.new(ApplicationConfig["BUFFER_ACCESS_TOKEN"])
    client.create_update(
      body: {
        text:
        text,
        profile_ids: [
          buffer_profile_id_code,
        ]
      },
    )
  end

  private

  def validate_body_text_recent_uniqueness
    if BufferUpdate.where(body_text: body_text, article_id: article_id, tag_id: tag_id, social_service_name: social_service_name).
        where("created_at > ?", 2.minutes.ago).any?
      errors.add(:body_text, "\"#{body_text}\" has already been submitted very recently")
    end
  end
end
