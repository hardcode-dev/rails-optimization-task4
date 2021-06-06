class AddSourceUrlToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :feed_source_url, :string
  end
end
