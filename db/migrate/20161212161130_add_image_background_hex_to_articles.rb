class AddImageBackgroundHexToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :main_image_background_hex_color, :string, default: "#dddddd"
  end
end
