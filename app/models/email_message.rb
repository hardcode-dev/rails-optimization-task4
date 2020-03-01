# == Schema Information
#
# Table name: ahoy_messages
#
#  id                  :integer          not null, primary key
#  clicked_at          :datetime
#  content             :text
#  feedback_message_id :integer
#  mailer              :string
#  opened_at           :datetime
#  sent_at             :datetime
#  subject             :text
#  to                  :text
#  token               :string
#  user_id             :integer
#  user_type           :string
#  utm_campaign        :string
#  utm_content         :string
#  utm_medium          :string
#  utm_source          :string
#  utm_term            :string
#
class EmailMessage < Ahoy::Message
  # So far this is mostly used to be compatible with administrate gem,
  # which doesn't seem to play nicely with namespaces. But there could be other
  # reasons to define behavior here, similar to how we use the Tag model.
  def body_html_content
    doctype_index = content.index("<!DOCTYPE")
    closing_html_index = content.index("</html>") + 6
    content[doctype_index..closing_html_index]
  end

  def self.find_for_reports(feedback_message_ids)
    select(:to, :subject, :content, :utm_campaign, :feedback_message_id).
      where(feedback_message_id: feedback_message_ids)
  end
end
