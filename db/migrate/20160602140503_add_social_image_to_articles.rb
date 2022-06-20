class AddSocialImageToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :social_image, :string
  end
end
