class AddIdsForOtherArticlesToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :ids_for_suggested_articles, :string, default: "[]"
  end
end
