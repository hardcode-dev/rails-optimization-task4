class AddMainImageToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :main_image, :string
  end
end
