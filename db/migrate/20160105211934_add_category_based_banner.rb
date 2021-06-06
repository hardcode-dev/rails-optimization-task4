class AddCategoryBasedBanner < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :programming_category, :string
  end
end
