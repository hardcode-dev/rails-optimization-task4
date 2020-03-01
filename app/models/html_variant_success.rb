# == Schema Information
#
# Table name: html_variant_successes
#
#  id              :bigint(8)        not null, primary key
#  article_id      :integer
#  created_at      :datetime         not null
#  html_variant_id :integer
#  updated_at      :datetime         not null
#
class HtmlVariantSuccess < ApplicationRecord
  validates :html_variant_id, presence: true
  belongs_to :html_variant
  belongs_to :article, optional: true
end
