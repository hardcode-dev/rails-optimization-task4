class AddRedditCodeToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :reddit_identifier, :string
  end
end
