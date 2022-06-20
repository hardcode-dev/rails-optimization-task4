class AddRedditInfoToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :reddit_score, :integer, default: 0
  end
end
