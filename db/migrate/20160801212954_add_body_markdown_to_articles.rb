class AddBodyMarkdownToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :body_markdown, :text
  end
end
