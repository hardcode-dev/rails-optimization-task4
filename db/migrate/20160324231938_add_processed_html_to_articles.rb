class AddProcessedHtmlToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :processed_html, :text
  end
end
