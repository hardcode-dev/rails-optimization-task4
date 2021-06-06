class AddPublishedToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :published, :boolean, default:false
    add_column :articles, :password, :string
  end
end
