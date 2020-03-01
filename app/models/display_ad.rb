# == Schema Information
#
# Table name: display_ads
#
#  id                  :bigint(8)        not null, primary key
#  approved            :boolean          default("false")
#  body_markdown       :text
#  clicks_count        :integer          default("0")
#  cost_per_click      :float            default("0.0")
#  cost_per_impression :float            default("0.0")
#  created_at          :datetime         not null
#  impressions_count   :integer          default("0")
#  organization_id     :integer
#  placement_area      :string
#  processed_html      :text
#  published           :boolean          default("false")
#  updated_at          :datetime         not null
#
class DisplayAd < ApplicationRecord
  belongs_to :organization
  validates :organization_id, presence: true
  validates :placement_area, presence: true,
                             inclusion: { in: %w[sidebar] }
  validates :body_markdown, presence: true
  before_save :process_markdown

  private

  def process_markdown
    renderer = Redcarpet::Render::HTMLRouge.new(hard_wrap: true, filter_html: false)
    markdown = Redcarpet::Markdown.new(renderer)
    initial_html = markdown.render(body_markdown)
    stripped_html = ActionController::Base.helpers.sanitize initial_html.html_safe,
      tags: %w[a em i b u br img h1 h2 h3 h4 div],
      attributes: %w[href target src height width style]
    html = stripped_html.gsub("\n", "")
    self.processed_html = MarkdownParser.new(html).prefix_all_images(html, 350)
  end
end
