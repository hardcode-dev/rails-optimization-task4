class AddProcessedHtmlToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :body_markdown, :text
    add_column :comments, :processed_html, :text
  end
end
