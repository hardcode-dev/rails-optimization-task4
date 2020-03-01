# == Schema Information
#
# Table name: broadcasts
#
#  id             :integer          not null, primary key
#  body_markdown  :text
#  processed_html :text
#  sent           :boolean          default("false")
#  title          :string
#  type_of        :string
#
class Broadcast < ApplicationRecord
  has_many :notifications, as: :notifiable

  validates :title, :type_of, :processed_html, presence: true
  validates :type_of, inclusion: { in: %w[Announcement Onboarding] }

  def get_inner_body(content)
    Nokogiri::HTML(content).at("body").inner_html
  end
end
