# == Schema Information
#
# Table name: page_views
#
#  id                         :bigint(8)        not null, primary key
#  article_id                 :bigint(8)
#  counts_for_number_of_views :integer          default("1")
#  created_at                 :datetime         not null
#  referrer                   :string
#  time_tracked_in_seconds    :integer          default("15")
#  updated_at                 :datetime         not null
#  user_agent                 :string
#  user_id                    :bigint(8)
#
class PageView < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :article
end
