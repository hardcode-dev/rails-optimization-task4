class AddUrlToAdvertisments < ActiveRecord::Migration[5.1]
  def change
    add_column :advertisements, :url, :text
  end
end
