class AddCommentToggleToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :show_comments, :boolean, default: false
  end
end
