# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  author_id     :integer
#  content       :text
#  created_at    :datetime         not null
#  noteable_id   :integer
#  noteable_type :string
#  reason        :string
#  updated_at    :datetime         not null
#
class Note < ApplicationRecord
  belongs_to :noteable, polymorphic: true, touch: true
  belongs_to :author, class_name: "User", optional: true
  validates :content, :reason, presence: true
end
