class AddCanonicalUrlToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :canonical_url, :string
  end
end
