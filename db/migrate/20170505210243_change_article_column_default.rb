class ChangeArticleColumnDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:articles, :show_comments, true)
  end
end
